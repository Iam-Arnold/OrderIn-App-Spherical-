import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/colors.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in, fetch user details
      String userName = user.displayName ?? 'Guest';
      String userProfilePicture = user.photoURL ?? '';
      Navigator.pushReplacementNamed(
        context,
        '/main',
        arguments: {'userName': userName, 'userProfilePicture': userProfilePicture},
      );
    } else {
      // User is not signed in, navigate to welcome screen after the timer
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/welcome');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/dartorderinLogo.png', height: 100.0),
            SizedBox(height: 20.0),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.ultramarineBlue),
            ),
          ],
        ),
      ),
    );
  }
}
