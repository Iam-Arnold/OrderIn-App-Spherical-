import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
          notifyListeners();
        }
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

  Future<void> updateUserName(String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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
}
