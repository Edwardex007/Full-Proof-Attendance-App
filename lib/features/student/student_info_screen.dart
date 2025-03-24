// Import Flutter's material package for UI components.
import 'package:flutter/material.dart';
// Import Geolocator package for accessing device location.
import 'package:geolocator/geolocator.dart';
// Import the QR scanner screen to navigate to after gathering student info.
import 'qr_scanner_screen.dart'; // Import the next screen

// Define a stateful widget for the student information screen.
class StudentInfoScreen extends StatefulWidget {
  @override
  _StudentInfoScreenState createState() => _StudentInfoScreenState();
}

// The state class for StudentInfoScreen.
class _StudentInfoScreenState extends State<StudentInfoScreen> {
  // Controller for the name input field.
  final TextEditingController _nameController = TextEditingController();
  // Controller for the student number input field.
  final TextEditingController _numberController = TextEditingController();
  // Variable to store the current position (latitude and longitude).
  Position? _currentPosition;

  // Function to retrieve the current location of the device.
  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // ✅ Check if location services are enabled on the device.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌ Location services are disabled.");
      return;
    }

    // ✅ Check the current location permission status.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // If permission is denied, request permission from the user.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("❌ Location permissions are denied.");
        return;
      }
    }

    // Handle the case where permissions are permanently denied.
    if (permission == LocationPermission.deniedForever) {
      print("❌ Location permissions are permanently denied.");
      return;
    }

    // ✅ Get the current location with high accuracy.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Update the UI with the new location.
    setState(() {
      _currentPosition = position;
    });

    print("📍 Location Retrieved: ${position.latitude}, ${position.longitude}");
  }

  // Function to navigate to the QR Scanner screen once all details are provided.
  void _proceedToNextScreen() {
    // Check if both name and student number are provided.
    if (_nameController.text.isEmpty || _numberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Please enter your details!")));
      return;
    }

    // Check if the location has been fetched.
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Please enable location services!")));
      return;
    }

    // ✅ Navigate to the QR scanner page with student info and location.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(
          studentId: _numberController.text, // Use student number as the ID.
          studentName: _nameController.text,   // Pass the entered name.
          latitude: _currentPosition!.latitude,  // Pass the fetched latitude.
          longitude: _currentPosition!.longitude, // Pass the fetched longitude.
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Auto-fetch the current location as soon as the screen loads.
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with a title for the screen.
      appBar: AppBar(title: Text("Student Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Apply padding around the content.
        child: Column(
          children: [
            // Text field for entering the student's name.
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Enter Name"),
            ),
            // Text field for entering the student number.
            TextField(
              controller: _numberController,
              decoration: InputDecoration(labelText: "Enter Student Number"),
              keyboardType: TextInputType.number, // Use numeric keyboard.
            ),
            SizedBox(height: 20), // Spacer for layout separation.
            // Display a progress indicator while location is being fetched.
            // Once fetched, display the current location coordinates.
            _currentPosition == null
                ? CircularProgressIndicator()
                : Text("📍 Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}"),
            SizedBox(height: 20), // Additional spacing before the button.
            // Elevated button to proceed to the next screen.
            ElevatedButton(
              onPressed: _proceedToNextScreen,
              child: Text("Proceed to Attendance"),
            ),
          ],
        ),
      ),
    );
  }
}
