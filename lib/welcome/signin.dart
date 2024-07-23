import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orderinapp/main.dart';
import 'package:orderinapp/welcome/loading_screen.dart';
import 'package:orderinapp/welcome/welcome_screen.dart';
import '../utils/colors.dart';
import '../components/primary_button.dart';
import '../authentication/auth_service.dart';
import '../authentication/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //final AuthService _auth = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  User? _user;
  
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event){
      setState((){
        _user = event;
      //   if (_user != null) {
      //   _showSuccessDialog();
      // } else {
      //   _showErrorDialog();
      // }
      });
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Account Created'),
          content: Text('Successfully created an account.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/welcome');
              },
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sign In Error'),
          content: Text('There was an error signing in with Google.'),
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

  @override
  void dispose() {
    _googleSignInService.isSignedIn.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _user != null ? WelcomeScreen() : Stack(
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
          // Sign-in content
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
                    'Sign in to your Account',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    height: 50.0,
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
                      //Navigator.pushReplacementNamed(context, '/main');
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text(
                      "Don't have an account? Sign up",
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
