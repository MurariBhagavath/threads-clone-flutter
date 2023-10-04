import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:threads_clone/screens/dashboard/home_screen.dart';
import 'package:threads_clone/screens/helper_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Threads',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xff101010),
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HelperScreen();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              } else {
                return AuthScreen();
              }
            }),
      ),
    );
  }
}
