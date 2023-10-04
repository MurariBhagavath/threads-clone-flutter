import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/widgets/dimensions.dart';
import 'package:threads_clone/widgets/search_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final searchController = SearchController();

  Stream<QuerySnapshot<Map<String, dynamic>>> searchUsers(String value) {
    return firestore
        .collection('users')
        .where('username',
            isGreaterThanOrEqualTo: value,
            isLessThan: value + 'z',
            isNotEqualTo: auth.currentUser!.displayName)
        .limit(15)
        .snapshots();
  }

  var username = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              buildHeight(12),
              SearchBar(
                controller: searchController,
                hintText: 'Search',
                hintStyle: MaterialStatePropertyAll(
                    TextStyle(color: Colors.white38, fontSize: 16)),
                leading: Icon(
                  Icons.search,
                  color: Colors.white38,
                ),
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 16)),
                onChanged: (value) {
                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      username = value;
                    });
                  });
                },
              ),
              StreamBuilder(
                stream: searchUsers(username),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data();
                        return SearchCard(
                            username: data['username'],
                            imageUrl: data['imageUrl'],
                            uid: data['uid'],
                            followers: data['followers'],
                            following: data['following']);
                      },
                    );
                  } else {
                    return Text("Sorry");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
