import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:threads_clone/widgets/dimensions.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.globe,
                  size: 26,
                ),
                Spacer(),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.instagram,
                      size: 26,
                    ),
                    buildWidth(24),
                    FaIcon(
                      FontAwesomeIcons.bars,
                      size: 26,
                    ),
                  ],
                ),
              ],
            ),
          ),
          buildHeight(8),
          //info card
          ListTile(
            title: Text(
              auth.currentUser!.displayName.toString(),
              style: TextStyle(fontSize: 22),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(auth.currentUser!.email.toString()),
            ),
            trailing: CircleAvatar(
              radius: 32,
              backgroundImage:
                  NetworkImage(auth.currentUser!.photoURL.toString()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: FutureBuilder(
              future: firestore
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.data();
                  return Text(
                    data!['followers'].length.toString() + ' followers',
                    style: TextStyle(color: Colors.white38),
                  );
                } else {
                  return Text('Loading...');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Edit profile',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                buildWidth(12),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Share profile',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: tabController,
            tabs: [
              Tab(text: "Threads"),
              Tab(text: "Replies"),
            ],
          ),
          TabBarView(
            controller: tabController,
            children: [
              Tab(text: "Threads"),
              Tab(text: "Replies"),
            ],
          ),
        ],
      ),
    );
  }
}
