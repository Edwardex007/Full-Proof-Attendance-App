import 'package:flutter/material.dart'; // Flutter UI toolkit
import 'package:provider/provider.dart'; // Provider for state management
import '../../core/services/auth_service.dart'; // Auth service to handle Firebase registration

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState(); // Create state
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController(); // Controller for email field
  final _passwordController = TextEditingController(); // Controller for password field
  bool _isLoading = false; // Flag to show loading indicator during async call

  // Handles user registration
  void _register() async {
    setState(() {
      _isLoading = true; // Show progress indicator
    });

    try {
      // Attempt to register user
      await Provider.of<AuthService>(context, listen: false)
          .signUp(_emailController.text, _passwordController.text);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Successful! Please login.")),
      );

      Navigator.pop(context); // Navigate back to login screen
    } catch (e) {
      // Show error message if registration fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Failed: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")), // App bar title
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around content
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
            SizedBox(height: 16), // Space before button
            _isLoading
                ? CircularProgressIndicator() // Show loader while waiting
                : ElevatedButton(
              onPressed: _register, // Trigger registration
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
