import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'pin_input_page.dart';

class RegisterPhonePage extends StatefulWidget {
  @override
  _RegisterPhonePageState createState() => _RegisterPhonePageState();
}

class _RegisterPhonePageState extends State<RegisterPhonePage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  String _completePhoneNumber = '';

  Future<void> _sendOTP() async {
    if (_completePhoneNumber.isNotEmpty) {
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: _completePhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-retrieval or instant verification
            await _auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to send OTP: ${e.message}')),
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _verificationId = verificationId;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PinInputPage(
                  verificationId: verificationId,
                  phoneNumber: _completePhoneNumber,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            setState(() {
              _verificationId = verificationId;
            });
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IntlPhoneField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'US', // Change this to your desired default country code
              onChanged: (phone) {
                setState(() {
                  _completePhoneNumber = phone.completeNumber;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendOTP,
              child: Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
