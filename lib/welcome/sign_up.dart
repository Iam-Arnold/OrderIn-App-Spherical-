import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/primary_button.dart';
import '../authentication/auth_service.dart';
import '../authentication/google_sign_in.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();
  final GoogleSignInService _googleSignInService = GoogleSignInService();
  final _formKey = GlobalKey<FormState>();

  // Text field state
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  String error = '';

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
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        'Create an Account',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: AppColors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          labelText: 'First Name',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (val) => val!.isEmpty ? 'Enter your first name' : null,
                        onChanged: (val) {
                          setState(() => firstName = val);
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          labelText: 'Last Name',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (val) => val!.isEmpty ? 'Enter your last name' : null,
                        onChanged: (val) {
                          setState(() => lastName = val);
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        obscureText: true,
                        validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 32.0),
                      PrimaryButton(
                        text: 'Sign Up',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            dynamic result = await _auth.registerWithEmailPassword(
                              email,
                              password,
                              firstName,
                              lastName,
                            );
                            if (result == null) {
                              setState(() => error = 'Please supply a valid email');
                            } else {
                              Navigator.pushReplacementNamed(context, '/main');
                            }
                          }
                        },
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton.icon(
                        onPressed: () async {
                          dynamic result = await _googleSignInService.signInWithGoogle();
                          if (result != null) {
                            Navigator.pushReplacementNamed(context, '/main');
                          } else {
                            // Handle error
                          }
                        },
                        icon: Icon(Icons.email, color: Colors.white),
                        label: Text('Sign Up with Google'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDB4437), // Google color
                          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                          textStyle: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signIn'); // Navigate to login page
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
            ),
          ),
        ],
      ),
    );
  }
}
