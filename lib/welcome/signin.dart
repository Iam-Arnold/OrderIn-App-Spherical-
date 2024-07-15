import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/primary_button.dart';
import '../authentication/auth_service.dart';
import '../authentication/google_sign_in.dart';

class SignInScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final GoogleSignInService _googleSignInService = GoogleSignInService();

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
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        dynamic result = await _googleSignInService.signInWithGoogle();
                        if (result != null) {
                          Navigator.pushReplacementNamed(context, '/main');
                        }else{
                          showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Sign In Error'),
                              content: Text('There was an error signing in with Google: $result'),
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
                      } catch (error) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Sign In Error'),
                              content: Text('There was an error signing in with Google: $error'),
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
                    },
                    icon: Icon(Icons.email, color: Colors.white),
                    label: Text('Continue with Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDB4437), // Google color
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                      textStyle: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('or', style: TextStyle(color: AppColors.grey)),
                  SizedBox(height: 16.0),
                  PrimaryButton(
                    text: 'Continue as Guest',
                    onPressed: () {
                      // Handle guest sign-in
                      Navigator.pushReplacementNamed(context, '/main');
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
