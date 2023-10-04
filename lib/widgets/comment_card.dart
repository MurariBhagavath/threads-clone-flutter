import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/widgets/dimensions.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    super.key,
    required this.uid,
    required this.threadUid,
    required this.commentUid,
    required this.imageUrl,
    required this.content,
    required this.timestamp,
    required this.username,
    required this.likes,
    required this.comments,
  });
  final String uid;
  final String threadUid;
  final String commentUid;
  final String imageUrl;
  final String content;
  final Timestamp timestamp;
  final String username;
  final List<dynamic> likes;
  final List<dynamic> comments;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  void likeComment() async {
    if (widget.likes.contains(auth.currentUser!.uid)) {
      await firestore
          .collection('threads')
          .doc(widget.threadUid)
          .collection('comments')
          .doc(widget.commentUid)
          .update({
        "likes": FieldValue.arrayRemove([auth.currentUser!.uid]),
      });
    } else {
      await firestore
          .collection('threads')
          .doc(widget.threadUid)
          .collection('comments')
          .doc(widget.commentUid)
          .update({
        "likes": FieldValue.arrayUnion([auth.currentUser!.uid]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.white24))),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.imageUrl),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: Text(
            widget.username,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.content,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      likeComment();
                    },
                    child: widget.likes.contains(auth.currentUser!.uid)
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_border),
                  ),
                  buildWidth(12),
                  GestureDetector(child: Icon(Icons.mode_comment_outlined)),
                  buildWidth(12),
                  GestureDetector(child: Icon(Icons.repeat)),
                  buildWidth(12),
                  GestureDetector(child: Icon(Icons.send)),
                ],
              ),
            ),
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
        trailing: Icon(Icons.more_horiz),
      ),
    );
  }
}
