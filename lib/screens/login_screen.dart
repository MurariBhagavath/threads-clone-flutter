// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/widgets/auth_button.dart';
import 'package:threads_clone/widgets/auth_input.dart';
import 'package:threads_clone/widgets/dimensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.toggleView});
  final VoidCallback toggleView;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var usernameController = new TextEditingController();
  var passwordController = new TextEditingController();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  void loginUser() async {
    var userDoc = await firestore
        .collection('users')
        .where('username', isEqualTo: usernameController.text.trim())
        .get();
    if (userDoc.docs.isEmpty) {
      print('no user found');
    } else {
      var email = userDoc.docs[0].data()['email'].toString();
      try {
        UserCredential userAuth = await auth.signInWithEmailAndPassword(
            email: email, password: passwordController.text.trim());
        print(userAuth.user!.uid);
      } on FirebaseAuthException catch (e) {
        print(e.message);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/Threads_black.png',
            height: 120,
          ),
          buildHeight(24),
          AuthInput(
            textController: usernameController,
            hint: 'username',
            icon: Icon(Icons.person),
          ),
          AuthInput(
            textController: passwordController,
            hint: 'password',
            icon: Icon(Icons.key),
          ),
          buildHeight(12),
          AuthButton(
              title: 'Login',
              onTap: () {
                loginUser();
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Don't have an account?"),
                GestureDetector(
                  onTap: widget.toggleView,
                  child: Text(
                    "SignUp",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
