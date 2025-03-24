// Import Flutter's material package for UI components.
import 'package:flutter/material.dart';
// Import the mobile_scanner package to enable QR code scanning.
import 'package:mobile_scanner/mobile_scanner.dart';
// Import the Firestore service to handle attendance marking in the backend.
import '../../firebase/firestore_service.dart';

// Define a stateful widget for the student attendance screen.
class StudentAttendanceScreen extends StatefulWidget {
  // Unique identifier for the student.
  final String studentId;
  // Name of the class for which attendance is being marked.
  final String className;

  // Constructor requiring the studentId and className.
  StudentAttendanceScreen({required this.studentId, required this.className});

  @override
  _StudentAttendanceScreenState createState() => _StudentAttendanceScreenState();
}

// The state class for StudentAttendanceScreen.
class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  // Function to process the scanned QR code.
  // Although the scannedCode is provided, this implementation simply marks attendance.
  void _processScan(String scannedCode) async {
    // Mark attendance for the student using FirestoreService.
    await FirestoreService().markAttendance(widget.studentId, widget.className);
    // Show a confirmation message to the user using a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Attendance marked successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with the title indicating the screen's purpose.
      appBar: AppBar(title: Text("Scan QR Code")),
      // Body of the screen contains the MobileScanner widget.
      body: MobileScanner(
        // Callback function that triggers when a barcode/QR code is detected.
        onDetect: (barcode) {
          // Ensure at least one barcode has been detected.
          if (barcode.barcodes.isNotEmpty) {
            // Extract the raw value from the first detected barcode.
            String? scannedCode = barcode.barcodes.first.rawValue;
            // If a valid scanned code exists, process it.
            if (scannedCode != null) {
              _processScan(scannedCode);
            }
          }
        },
      ),
    );
  }
}
