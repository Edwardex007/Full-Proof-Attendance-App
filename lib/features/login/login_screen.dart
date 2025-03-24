import 'package:flutter/material.dart'; // Flutter material widgets
import 'package:flutterapp/core/services/auth_service.dart'; // Authentication service
import 'package:provider/provider.dart'; // Provider package for state management

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState(); // Create state for login form
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(); // Controller for email input
  final _passwordController = TextEditingController(); // Controller for password input

  // Login logic using AuthService
  void _login() async {
    try {
      // Attempt to sign in using credentials
      await Provider.of<AuthService>(context, listen: false)
          .signIn(_emailController.text, _passwordController.text);

      // Navigate to home screen if login succeeds
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Display error message on login failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")), // App bar with title
      body: Padding(
        padding: EdgeInsets.all(16), // Padding around form fields
        child: Column(
          children: [
            // Email input field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            // Password input field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20), // Spacing before button
            // Login button
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
            // Link to registration screen
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
