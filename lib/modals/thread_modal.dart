import 'package:cloud_firestore/cloud_firestore.dart';

class ThreadModal {
  final String uid;
  final String threadUid;
  final String username;
  final String content;
  final String imageUrl;
  final Timestamp timestamp;
  final List<String> likes;
  final List<String> comments;

  ThreadModal({
    required this.uid,
    required this.threadUid,
    required this.username,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  factory ThreadModal.fromJson(Map<String, dynamic> json) => ThreadModal(
        uid: json['uid'],
        threadUid: json['threadUid'],
        username: json['username'],
        content: json['content'],
        timestamp: json['timestamp'],
        imageUrl: json['imageUrl'],
        likes: json['likes'],
        comments: json['comments'],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "threadUid": threadUid,
        'username': username,
        'content': content,
        'timestamp': timestamp,
        'imageUrl': imageUrl,
        'likes': likes,
        'comments': comments,
      };
}
