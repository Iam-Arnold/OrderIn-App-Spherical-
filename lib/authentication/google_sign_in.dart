import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    // clientId: '474792991550-3c4qacc9fc1747746248leben37gj7t3.apps.googleusercontent.com',
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ValueNotifier<bool> isSignedIn = ValueNotifier<bool>(false);

  // Sign in or Sign up with Google
  Future<void> signInWithGoogle({String? phoneNumber}) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isSignedIn.value = false; // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        DocumentReference userRef = _firestore.collection('users').doc(user.uid);
        DocumentSnapshot userDoc = await userRef.get();

        if (userDoc.exists) {
          // Fetch existing details if user document exists
          Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
          if (userData != null) {
            // Use existing details
            String existingName = userData['name'] ?? user.displayName ?? '';
            String existingProfilePicture = userData['profilePicture'] ?? user.photoURL ?? '';
            String existingEmail = userData['email'] ?? user.email ?? '';
            String existingPhoneNumber = userData['phoneNumber'] ?? phoneNumber ?? '';

            // Update local user details (optional, depending on your app's logic)
            // _userName = existingName;
            // _userProfilePicture = existingProfilePicture;
            // _userEmail = existingEmail;
            // _userPhoneNumber = existingPhoneNumber;

            // Ensure that the Firestore document is up-to-date with any new information
            await userRef.update({
              'name': existingName,
              'profilePicture': existingProfilePicture,
              'email': existingEmail,
              'phoneNumber': existingPhoneNumber,
            });
          }
        } else {
          // Create new user document if it does not exist
          await userRef.set({
            'uid': user.uid,
            'name': user.displayName,
            'email': user.email,
            'profilePicture': user.photoURL,
            'phoneNumber': phoneNumber ?? '', // Save phone number if available
          });
        }
        isSignedIn.value = true;
      } else {
        isSignedIn.value = false;
      }
    } catch (error) {
      print(error.toString());
      isSignedIn.value = false;
    }
  }

  // Sign out Google
  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    print("User Signed Out");
    isSignedIn.value = false;
  }
}
