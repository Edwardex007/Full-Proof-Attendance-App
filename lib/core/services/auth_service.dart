import 'package:flutter/foundation.dart'; // Provides ChangeNotifier for state updates
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication package

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instance of FirebaseAuth to handle auth

  // Getter to return the currently signed-in Firebase user
  User? get user => _auth.currentUser;

  // Sign up a new user using email and password
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password); // Firebase sign-up
      notifyListeners(); // Notify listeners of authentication state change
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message); // Re-throw Firebase-specific error with message
    }
  }

  // Sign in an existing user using email and password
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password); // Firebase sign-in
      notifyListeners(); // Notify UI about the new auth state
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message); // Pass meaningful error up to UI
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut(); // Sign out from Firebase
    notifyListeners(); // Notify UI about the sign-out
  }
}
