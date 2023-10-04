// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:threads_clone/modals/thread_modal.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final inputController = TextEditingController();
  final inputNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  void addThread() async {
    if (_formKey.currentState!.validate()) {
      var docRef = firestore.collection('threads').doc();
      var thread = new ThreadModal(
        uid: auth.currentUser!.uid,
        threadUid: docRef.id,
        username: auth.currentUser!.displayName.toString(),
        content: inputController.text.trim(),
        imageUrl: auth.currentUser!.photoURL.toString(),
        timestamp: Timestamp.now(),
        likes: [],
        comments: [],
      );
      await firestore.collection('threads').doc(docRef.id).set(thread.toJson());
      Navigator.pop(context);
      inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Color(0xff181818),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          //header
          Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white24))),
            width: double.infinity,
            padding: EdgeInsets.all(24),
            child: Stack(
              children: [
                Positioned(
                    top: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    )),
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'New thread',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          auth.currentUser!.photoURL.toString(),
                          width: 45,
                          height: 45,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 64,
                          child: VerticalDivider(
                            thickness: 3,
                            width: 2,
                            color: Colors.white12,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          auth.currentUser!.photoURL.toString(),
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.currentUser!.displayName.toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your message";
                                }
                              },
                              controller: inputController,
                              autofocus: true,
                              focusNode: inputNode,
                              cursorWidth: 3,
                              maxLines: 3,
                              maxLength: 300,
                              decoration: InputDecoration(
                                hintText: 'Start a thread...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.white24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: 45,
                              child: Icon(
                                Icons.attach_file,
                                color: Colors.white24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your followers can reply',
                  style: TextStyle(color: Colors.white38),
                ),
                TextButton(
                    onPressed: () {
                      addThread();
                    },
                    child: Text('Post')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
