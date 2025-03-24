class User {
  final String uid; // Unique identifier for the user (from Firebase Auth)
  final String email; // User's email address

  // Constructor requiring both uid and email to be provided
  User({required this.uid, required this.email});
}
