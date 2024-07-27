import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  String _userName = '';
  String _userEmail = '';
  String _userProfilePicture = '';
  String _userPhoneNumber = '';

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userProfilePicture => _userProfilePicture;
  String get userPhoneNumber => _userPhoneNumber;

  UserProvider() {
    initializeUser().then((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          fetchUserDetails(user);
        }
        print(user);
      });
    });
  }

  Future<void> initializeUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await fetchUserDetails(user);
    }
  }

  Future<void> fetchUserDetails(User user) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          _userName = userData['name'] ?? '';
          _userProfilePicture = userData['profilePicture'] ?? '';
          _userEmail = user.email ?? '';
          _userPhoneNumber = userData['phoneNumber'] ?? '';
          print("Fetched Details: $_userName, $_userProfilePicture, $_userPhoneNumber");
          notifyListeners();
        }
      } else {
        print("No user document found for UID: ${user.uid}");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'phoneNumber': phoneNumber,
      });
      _userPhoneNumber = phoneNumber;
      notifyListeners();
    }
  }
}
