import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/widgets/comment_card.dart';
import 'package:threads_clone/widgets/thread_card.dart';

class ThreadScreen extends StatefulWidget {
  const ThreadScreen({
    super.key,
    required this.uid,
    required this.threadUid,
    required this.imageUrl,
    required this.username,
    required this.timestamp,
    required this.content,
    required this.likes,
    required this.comments,
  });
  final String uid;
  final String imageUrl;
  final String threadUid;
  final String username;
  final String content;
  final Timestamp timestamp;
  final List<dynamic> likes;
  final List<dynamic> comments;

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        centerTitle: true,
        backgroundColor: Color(0xff101010),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('threads')
                  .where('threadUid', isEqualTo: widget.threadUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.docs[0].data();
                  return ThreadCard(
                    uid: data['uid'],
                    threadUid: data['threadUid'],
                    imageUrl: data['imageUrl'],
                    username: data['username'],
                    timestamp: data['timestamp'],
                    content: data['content'],
                    likes: data['likes'],
                    comments: data['comments'],
                  );
                } else {
                  return Container();
                }
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('threads')
                  .doc(widget.threadUid)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.docs;
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index].data();
                      print(doc);
                      return CommentCard(
                        uid: doc['uid'],
                        threadUid: widget.threadUid,
                        commentUid: doc['commentUid'],
                        imageUrl: doc['imageUrl'],
                        username: doc['username'],
                        timestamp: doc['timestamp'],
                        content: doc['content'],
                        likes: doc['likes'],
                        comments: [],
                      );
                    },
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Some error occoured');
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
