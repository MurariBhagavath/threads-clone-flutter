// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/screens/dashboard/reply_screen.dart';
import 'package:threads_clone/screens/dashboard/thread_screen.dart';
import 'package:threads_clone/widgets/dimensions.dart';

class ThreadCard extends StatefulWidget {
  const ThreadCard({
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
  State<ThreadCard> createState() => _ThreadCardState();
}

class _ThreadCardState extends State<ThreadCard> {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  void likeThread() async {
    if (widget.likes.contains(auth.currentUser!.uid)) {
      await firestore.collection('threads').doc(widget.threadUid).update({
        'likes': FieldValue.arrayRemove([auth.currentUser?.uid])
      });
    } else {
      await firestore.collection('threads').doc(widget.threadUid).update({
        'likes': FieldValue.arrayUnion([auth.currentUser!.uid])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ThreadScreen(
                        uid: widget.uid,
                        threadUid: widget.threadUid,
                        imageUrl: widget.imageUrl,
                        username: widget.username,
                        timestamp: widget.timestamp,
                        content: widget.content,
                        likes: widget.likes,
                        comments: widget.comments,
                      )));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white24),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 75,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        widget.imageUrl,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: VerticalDivider(
                          thickness: 3,
                          width: 3,
                          color: Colors.white24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.username,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    widget.timestamp.toDate().day.toString(),
                                    style: TextStyle(color: Colors.white38),
                                  ),
                                ),
                                Icon(Icons.more_horiz),
                              ],
                            ),
                          ),
                        ],
                      ),
                      buildHeight(4),
                      Text(widget.content),
                      buildHeight(8),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        width: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                likeThread();
                              },
                              child:
                                  widget.likes.contains(auth.currentUser!.uid)
                                      ? Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.favorite_border,
                                        ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: ReplyScreen(
                                            uid: widget.uid,
                                            threadUid: widget.threadUid,
                                            imageUrl: widget.imageUrl,
                                            username: widget.username,
                                            content: widget.content,
                                          ),
                                        );
                                      });
                                },
                                child: Icon(Icons.mode_comment_outlined)),
                            Icon(Icons.repeat),
                            Icon(Icons.send_outlined),
                          ],
                        ),
                      ),
                      buildHeight(8),
                      Text(
                        widget.comments.length.toString() +
                            ' replies • ' +
                            widget.likes.length.toString() +
                            " likes",
                        style: TextStyle(
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
