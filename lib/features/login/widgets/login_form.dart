import 'package:flutter/material.dart'; // Flutter material widgets
import '../../../shared/widgets/custom_button.dart'; // Custom styled button used across the app

class LoginScreen extends StatelessWidget {
  // Text editing controllers to retrieve the input from user
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')), // App bar with title
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Apply padding to the screen
        child: Column(
          children: [
            // Email input field
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // Password input field with hidden input
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20), // Spacing between input and button
            CustomButton(
              label: 'Login', // Button text
              onPressed: () {
                // Handle login functionality here.
              },
            ),
          ],
        ),
      ),
    );
  }
}
