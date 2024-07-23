import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/orderinLogo.png', height: 100.0),
            SizedBox(height: 20.0),
            Text(
              user == null
                  ? 'Your premier overseas goods ordering app'
                  : "Let's get you started. \nOrder your dream product at an affordable price.",
              style: TextStyle(
                fontSize: 18.0,
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.0),
            PrimaryButton(
              text: 'Next',
              onPressed: () {
                if (user != null) {
                  // User is signed in, fetch user details
                  String userName = user?.displayName ?? 'Guest';
                  String userProfilePicture = user?.photoURL ?? '';
                  String userEmail = user?.email ?? '';
                  Navigator.pushReplacementNamed(
                    context,
                    '/main',
                    arguments: {
                      'userName': userName,
                      'userProfilePicture': userProfilePicture,                      
                      'userEmail': userEmail,
                    },
                  );
                } else {
                  Navigator.pushReplacementNamed(context, '/signIn');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
