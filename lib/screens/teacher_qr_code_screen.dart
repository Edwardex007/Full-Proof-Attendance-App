// Import Flutter's material design package for UI components.
import 'package:flutter/material.dart';
// Import dart:async to use Timer for scheduling periodic tasks.
import 'dart:async';
// Import qr_flutter package to generate and display QR codes.
import 'package:qr_flutter/qr_flutter.dart';

// Define a stateful widget for the teacher's QR code screen.
class TeacherQRCodeScreen extends StatefulWidget {
  @override
  _TeacherQRCodeScreenState createState() => _TeacherQRCodeScreenState();
}

// State class for TeacherQRCodeScreen that manages the dynamic QR code data.
class _TeacherQRCodeScreenState extends State<TeacherQRCodeScreen> {
  // Initial QR data that will be encoded in the QR code.
  String qrData = "Initial data";
  // Timer that will be used to update the QR code data periodically.
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Set up a periodic timer that triggers every 30 seconds.
    // Each time the timer fires, generateQRData() is called to update the QR data.
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => generateQRData());
  }

  // Function to generate new QR code data.
  // It updates the state with the current time as part of the data.
  void generateQRData() {
    setState(() {
      // Update the qrData string with the current DateTime.
      qrData = "Data at ${DateTime.now()}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with a title indicating the purpose of the screen.
      appBar: AppBar(title: Text("Generate QR")),
      // The body contains a centered QR code image.
      body: Center(
        // QrImage widget from the qr_flutter package to display the QR code.
        child: QrImage(
          data: qrData, // The data to encode into the QR code.
          version: QrVersions.auto, // Automatically determine the QR code version.
          size: 200.0, // Specify the size of the QR code image.
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to free up resources.
    timer?.cancel();
    super.dispose();
  }
}
