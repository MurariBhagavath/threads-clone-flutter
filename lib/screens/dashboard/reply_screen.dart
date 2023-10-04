import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/widgets/dimensions.dart';
import 'package:uuid/uuid.dart';

class ReplyScreen extends StatefulWidget {
  const ReplyScreen({
    super.key,
    required this.uid,
    required this.threadUid,
    required this.imageUrl,
    required this.content,
    required this.username,
  });
  final String uid;
  final String threadUid;
  final String imageUrl;
  final String content;
  final String username;

  @override
  State<ReplyScreen> createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final inputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final uuid = new Uuid();

  void replyThread() async {
    if (_formKey.currentState!.validate()) {
      var docRef = uuid.v4();
      await firestore
          .collection('threads')
          .doc(widget.threadUid)
          .collection('comments')
          .doc(docRef)
          .set({
        'content': inputController.text.trim(),
        'timestamp': Timestamp.now(),
        'uid': auth.currentUser!.uid,
        'commentUid': docRef,
        'username': auth.currentUser!.displayName,
        "imageUrl": auth.currentUser!.photoURL,
        "likes": [],
        "comments": [],
        "threadUid": widget.threadUid
      });
      await firestore.collection('threads').doc(widget.threadUid).update({
        'comments': FieldValue.arrayUnion([docRef]),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Color(0xff101010),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white24))),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Text('Cancel'),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Reply',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ),
          buildHeight(4),
          Stack(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 14),
                leading: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(widget.imageUrl),
                    ),
                    SizedBox(
                      child: VerticalDivider(
                        width: 3,
                        thickness: 3,
                        color: Colors.white24,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  widget.username,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    widget.content,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                top: 72,
                left: 35,
                child: SizedBox(
                  height: 42,
                  child: VerticalDivider(
                    color: Colors.white24,
                    thickness: 3,
                    width: 3,
                  ),
                ),
              ),
            ],
          ),
          buildHeight(8),
          Stack(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    auth.currentUser!.photoURL.toString(),
                  ),
                  radius: 22,
                ),
                title: Text(auth.currentUser!.displayName.toString()),
                subtitle: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Reply to ' + widget.username,
                        ),
                        maxLines: 2,
                        controller: inputController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter something';
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Transform.rotate(
                          angle: 45,
                          child: Icon(
                            Icons.attach_file,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 72,
                left: 35,
                child: SizedBox(
                  height: 42,
                  child: VerticalDivider(
                    color: Colors.white24,
                    thickness: 3,
                    width: 3,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Anyone can reply',
                  style: TextStyle(color: Colors.white24),
                ),
              ),
              TextButton(
                  onPressed: () {
                    replyThread();
                  },
                  child: Text('Post')),
            ],
          ),
        ],
      ),
    );
  }
}
