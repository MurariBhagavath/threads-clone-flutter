import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/modals/user_modal.dart';
import 'package:threads_clone/widgets/auth_button.dart';
import 'package:threads_clone/widgets/auth_input.dart';
import 'package:threads_clone/widgets/dimensions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.toggleView});
  final VoidCallback toggleView;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var usernameController = new TextEditingController();
  var passwordController = new TextEditingController();
  var emailController = new TextEditingController();
  var confirmPasswordController = new TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  void signUpUser() async {
    var findUser = await firestore
        .collection('users')
        .where('username', isEqualTo: usernameController.text.trim())
        .get();
    if (findUser.docs.isEmpty) {
      try {
        UserCredential userAuth = await auth.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        if (userAuth.user != null) {
          await userAuth.user!
              .updateDisplayName(usernameController.text.trim());
          await userAuth.user!.updatePhotoURL(
              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png');
          User user = userAuth.user!;
          await user.reload();
          var newUser = UserModal(
            uid: userAuth.user!.uid,
            username: usernameController.text.trim(),
            email: emailController.text.trim(),
            imageUrl:
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png',
            followers: [],
            following: [],
          );
          firestore
              .collection('users')
              .doc(userAuth.user!.uid)
              .set(newUser.toJson());
        }
        print(auth.currentUser?.displayName);
      } on FirebaseAuthException catch (e) {
        print(e.code);
      } catch (err) {
        print(err);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Username already exists')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/Threads_black.png',
                height: 120,
              ),
              buildHeight(24),
              AuthInput(
                textController: emailController,
                hint: 'email',
                icon: Icon(Icons.email_outlined),
              ),
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
              AuthInput(
                textController: confirmPasswordController,
                hint: 'confirm password',
                icon: Icon(Icons.key),
              ),
              buildHeight(12),
              AuthButton(
                  title: 'SignUp',
                  onTap: () {
                    signUpUser();
                  }),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: widget.toggleView,
                      child: Text(
                        "SignIn",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
