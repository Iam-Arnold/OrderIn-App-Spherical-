import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/primary_button.dart';
import '../authentication/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  @override
  void initState() {
    super.initState();
    _googleSignInService.isSignedIn.addListener(() {
      if (_googleSignInService.isSignedIn.value) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Sign Up Error'),
              content: Text('There was an error signing up with Google.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _googleSignInService.isSignedIn.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/cargoflight.jpg'), // Adjust the path as needed
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.ultramarineBlue.withOpacity(0.8),
                  Color.fromARGB(255, 9, 8, 10).withOpacity(0.6),
                  Color.fromARGB(255, 9, 8, 10).withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Sign-up content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16.0),
                  SizedBox(height: 32.0),
                  Text(
                    'Create a New Account',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    height: 60.0,
                    child: SignInButton(
                      Buttons.Google,
                      onPressed: () {
                        _googleSignInService.signInWithGoogle();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('or', style: TextStyle(color: AppColors.grey)),
                  SizedBox(height: 16.0),
                  PrimaryButton(
                    text: 'Continue as Guest',
                    onPressed: () {
                      // Handle guest sign-in
                     // Navigator.pushReplacementNamed(context, '/main');
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signin');
                    },
                    child: Text(
                      'Already have an account? Sign in',
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
