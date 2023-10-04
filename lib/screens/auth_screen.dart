import 'package:flutter/material.dart';
import 'package:threads_clone/screens/login_screen.dart';
import 'package:threads_clone/screens/signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (showSignIn)
        ? LoginScreen(toggleView: toggleView)
        : SignUpScreen(toggleView: toggleView);
  }
}
