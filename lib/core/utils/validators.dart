class Validators {
  // Validates the provided email address
  static String? validateEmail(String? email) {
    // Check if the email is null or empty
    if (email == null || email.isEmpty) return "Email is required.";

    // Regular expression pattern to validate standard email format
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) return "Invalid email format.";

    return null; // Return null if validation passes
  }

  // Validates the provided password
  static String? validatePassword(String? password) {
    // Check if password is null or less than 6 characters
    if (password == null || password.length < 6) return "Password must be at least 6 characters.";

    return null; // Return null if validation passes
  }
}
