// Import Flutter's material package for UI components.
import 'package:flutter/material.dart';
// Import Provider package to manage state and dependency injection.
import 'package:provider/provider.dart';
// Import the authentication service which contains methods for user login.
import '../../core/services/auth_service.dart'; // Import AuthService

// Define a stateful widget for the login screen.
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// The state class for LoginScreen.
class _LoginScreenState extends State<LoginScreen> {
  // Controllers for the email and password text fields.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Function to handle user login.
  void _login() async {
    try {
      // Attempt to sign in using the AuthService provided via Provider.
      // The 'listen: false' parameter indicates that this widget does not need to rebuild when AuthService updates.
      await Provider.of<AuthService>(context, listen: false)
          .signIn(_emailController.text, _passwordController.text);

      // On successful login, navigate to the home screen or dashboard.
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // If an error occurs, show a SnackBar with the error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with a title.
      appBar: AppBar(title: Text("Login")),
      // Body of the login screen with padding around the content.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email input field.
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            // Password input field with obscured text.
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true, // Masks the text for privacy.
            ),
            SizedBox(height: 16), // Space between fields and button.
            // ElevatedButton to trigger the login function.
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
