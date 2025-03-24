// Import necessary Flutter and Firebase packages for UI, Firebase initialization, and state management.
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Import the main app widget and route configurations.
import 'app/app.dart';
import 'app/routes.dart'; // ✅ Import predefined routes.
import 'core/services/auth_service.dart';
import 'firebase/firebase_options.dart'; // Import Firebase configuration options.

void main() async {
  // Ensure that widget binding is initialized before using platform channels.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using platform-specific options.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app and provide necessary services using MultiProvider.
  runApp(
    MultiProvider(
      providers: [
        // Provide an instance of AuthService throughout the widget tree.
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
      ],
      // Root widget of the application.
      child: const MyApp(),
    ),
  );
}

// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Title of the application.
      title: 'Fool Proof Attendance',
      // Set the application's theme with a primary blue swatch.
      theme: ThemeData(primarySwatch: Colors.blue),
      // Set the initial route when the app starts.
      initialRoute: '/',
      // Use predefined static routes from routes.dart.
      routes: appRoutes, // ✅ Use predefined static routes.
      // Handle dynamic route generation.
      onGenerateRoute: onGenerateRoute, // ✅ Handle dynamic routes.
    );
  }
}
