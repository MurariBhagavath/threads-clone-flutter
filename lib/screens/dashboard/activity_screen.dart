import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/widgets/dimensions.dart';
import 'package:threads_clone/widgets/search_card.dart';
import 'package:uuid/uuid.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            buildHeight(8),
            StreamBuilder(
              stream: firestore
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('activity')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.length > 0) {
                  var docs = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var docData = docs[index].data();
                      if (docData['category'] == "following") {
                        return StreamBuilder(
                          stream: firestore
                              .collection('users')
                              .doc(docData['uid'])
                              .snapshots(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.hasData) {
                              return SearchCard(
                                username: docData['username'],
                                imageUrl: docData['imageUrl'],
                                uid: docData['uid'],
                                followers:
                                    userSnapshot.data!.data()!['followers'],
                                following:
                                    userSnapshot.data!.data()!['following'],
                                activity: true,
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      }
                    },
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Some error occured!'));
                } else {
                  return Container(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'No Activity',
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
