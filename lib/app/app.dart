import 'package:flutter/material.dart';
import '/app/routes.dart'; // Import the routes table which defines navigation paths

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor with optional key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fool Proof Attendance', // Application title shown in task manager or web
      theme: ThemeData.light(), // Apply the default light theme for the app
      initialRoute: '/', // Define the starting screen route when app launches
      routes: appRoutes, // Provide the map of route names to screen widgets
      debugShowCheckedModeBanner: false, // Hide the "debug" label from top-right corner
    );
  }
}
