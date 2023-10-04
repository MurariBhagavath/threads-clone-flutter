import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SearchCard extends StatefulWidget {
  const SearchCard({
    super.key,
    required this.username,
    required this.imageUrl,
    required this.uid,
    required this.followers,
    required this.following,
    this.activity,
  });
  final String username;
  final String imageUrl;
  final String uid;
  final bool? activity;
  final List<dynamic> followers;
  final List<dynamic> following;

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  void followUser() async {
    var docId = Uuid().v4();
    if (widget.followers.contains(auth.currentUser!.uid)) {
      await firestore.collection('users').doc(widget.uid).update({
        'followers': FieldValue.arrayRemove([auth.currentUser?.uid])
      });
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'following': FieldValue.arrayRemove([widget.uid]),
      });
    } else {
      await firestore.collection('users').doc(widget.uid).update({
        'followers': FieldValue.arrayUnion([auth.currentUser?.uid])
      });
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'following': FieldValue.arrayUnion([widget.uid]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.imageUrl),
          radius: 22,
        ),
        title: Text(
          widget.username,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: (widget.activity == true)
            ? Text('has started following you')
            : Text(widget.followers.length.toString() + " followers"),
        trailing: GestureDetector(
          onTap: () {
            followUser();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white30),
                borderRadius: BorderRadius.circular(8)),
            child: widget.followers.contains(auth.currentUser!.uid)
                ? Text('Following')
                : Text('Follow'),
          ),
        ),
      ),
    );
  }
}
