import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProvider with ChangeNotifier {
  String _userName = '';
  String _userEmail = '';
  String _userProfilePicture = '';
  String _userPhoneNumber = '';

  // Previous values
  String _previousUserName = '';
  String _previousUserProfilePicture = '';
  String _previousUserPhoneNumber = '';

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userProfilePicture => _userProfilePicture;
  String get userPhoneNumber => _userPhoneNumber;

  UserProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        fetchUserDetails(user);
      } else {
        _clearUserData(); // Clear user data if not logged in
      }
    });
  }

  Future<void> fetchUserDetails(User user) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      
      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
        
        if (userData != null) {
          // Fetch details from Firestore
          _userName = userData['name'] ?? '';
          _userProfilePicture = userData['profilePicture'] ?? '';
          _userEmail = user.email ?? '';
          _userPhoneNumber = userData['phoneNumber'] ?? '';

          // Store the initial values as previous values
          _previousUserName = _userName;
          _previousUserProfilePicture = _userProfilePicture;
          _previousUserPhoneNumber = _userPhoneNumber;

          notifyListeners();
        }
      } else {
        // User document does not exist, so create it
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName ?? '',
          'profilePicture': user.photoURL ?? '',
          'email': user.email ?? '',
          'phoneNumber': '',
        });

        // Set local user details
        _userName = user.displayName ?? '';
        _userProfilePicture = user.photoURL ?? '';
        _userEmail = user.email ?? '';
        _userPhoneNumber = '';

        // Store the initial values as previous values
        _previousUserName = _userName;
        _previousUserProfilePicture = _userProfilePicture;
        _previousUserPhoneNumber = _userPhoneNumber;

        notifyListeners();
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _previousUserPhoneNumber = _userPhoneNumber; // Store previous phone number
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'phoneNumber': phoneNumber,
      });
      _userPhoneNumber = phoneNumber;
      notifyListeners();
    }
  }

  Future<void> updateUserName(String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _previousUserName = _userName; // Store previous user name
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': name,
      });
      _userName = name;
      notifyListeners();
    }
  }

  Future<void> updateProfilePicture(String filePath) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        _previousUserProfilePicture = _userProfilePicture; // Store previous profile picture
        // Upload image to Firebase Storage
        Reference storageReference = FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}');
        UploadTask uploadTask = storageReference.putFile(File(filePath));
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get download URL
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        // Update Firestore document
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'profilePicture': downloadURL,
        });

        _userProfilePicture = downloadURL;
        notifyListeners();
      } catch (e) {
        print("Error updating profile picture: $e");
      }
    }
  }

  // Method to revert to previous details
  Future<void> revertToPreviousDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _previousUserName,
        'profilePicture': _previousUserProfilePicture,
        'phoneNumber': _previousUserPhoneNumber,
      });

      _userName = _previousUserName;
      _userProfilePicture = _previousUserProfilePicture;
      _userPhoneNumber = _previousUserPhoneNumber;
      notifyListeners();
    }
  }

  // Method to logout the user
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      _clearUserData();
      notifyListeners();
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  // Clear user data
  void _clearUserData() {
    _userName = '';
    _userEmail = '';
    _userProfilePicture = '';
    _userPhoneNumber = '';
  }
}
