import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../user_auth/firebase_auth_implementation/firebase_auth_services.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService(); // Declare and initialize _auth

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }

  void _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if (email != null && password != null && email != ' ') {
      // Perform automatic login
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        // If login successful, navigate to home page
          Navigator.pushReplacementNamed(context, '/home');
      } else {
        // If login fails, navigate to login page
        Navigator.pushReplacementNamed(context, "/login");
      }
    } else {
      // If no saved user data, navigate to login page
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "SmartQuit",
          style: TextStyle(
            color:  Color(0xFFbbb0ea),
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
