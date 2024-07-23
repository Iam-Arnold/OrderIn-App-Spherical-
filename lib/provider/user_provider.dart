import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  String _userName = '';
  String _userProfilePicture = '';
  String _userEmail = '';

  String get userName => _userName;
  String get userProfilePicture => _userProfilePicture;
  String get userEmail => _userEmail;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProvider() {
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        _userName = userData['name'] ?? '';
        _userProfilePicture = userData['profilePicture'] ?? '';
        _userEmail = user.email ?? '';
        notifyListeners();
      }
    }
  }

  void setUser(String name, String picture, String email) {
    _userName = name;
    _userProfilePicture = picture;
    _userEmail = email;
    notifyListeners();
  }
}
