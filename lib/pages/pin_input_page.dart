import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/heart_beat_loader.dart';
import '../pages/chat_contact_page.dart';

class PinInputPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  PinInputPage({required this.verificationId, required this.phoneNumber});

  @override
  _PinInputPageState createState() => _PinInputPageState();
}

class _PinInputPageState extends State<PinInputPage> {
  final TextEditingController _pinController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _verifyPin(String pin) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: pin,
      );

      await _auth.signInWithCredential(credential);
      await _storeUserPhoneNumber(widget.phoneNumber);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatContactPage()),
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Pinput(
              controller: _pinController,
              length: 6,
              onCompleted: (pin) => _verifyPin(pin),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _verifyPin(_pinController.text),
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
