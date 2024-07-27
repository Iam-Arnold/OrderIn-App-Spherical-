import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneNumberRegistrationForm extends StatefulWidget {
  final VoidCallback onRegistrationComplete;

  PhoneNumberRegistrationForm({required this.onRegistrationComplete});

  @override
  _PhoneNumberRegistrationFormState createState() => _PhoneNumberRegistrationFormState();
}

class _PhoneNumberRegistrationFormState extends State<PhoneNumberRegistrationForm> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _verificationId = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IntlPhoneField(
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
          initialCountryCode: 'US',
          onChanged: (phone) {
            _phoneNumberController.text = phone.completeNumber;
          },
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _registerPhoneNumber,
          child: Text('Register'),
        ),
      ],
    );
  }

  Future<void> _registerPhoneNumber() async {
    final phoneNumber = _phoneNumberController.text;

    print('Attempting to verify phone number: $phoneNumber');

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          await _storeUserPhoneNumber(phoneNumber);
          widget.onRegistrationComplete();
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification failed of ${phoneNumber}: ${e.message}')));
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          _showOtpDialog();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _storeUserPhoneNumber(String phoneNumber) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'phoneNumber': phoneNumber,
        // Add other user information here if needed
      });
    }
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) async {
              if (value.length == 6) {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: _verificationId,
                  smsCode: value,
                );
                try {
                  await _auth.signInWithCredential(credential);
                  await _storeUserPhoneNumber(_phoneNumberController.text);
                  widget.onRegistrationComplete();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                }
              }
            },
          ),
        );
      },
    );
  }
}
