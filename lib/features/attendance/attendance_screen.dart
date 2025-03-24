import 'package:flutter/material.dart'; // Flutter material design package
import 'package:mobile_scanner/mobile_scanner.dart'; // QR code scanner package
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore package

class AttendanceScreen extends StatelessWidget {
  final String studentId; // ID of the student checking in

  // Constructor that requires the studentId to be passed
  AttendanceScreen({required this.studentId});

  // Method to mark attendance by verifying the scanned QR code
  void _markAttendance(String scannedCode) async {
    // Get the attendance document from Firestore
    var doc = await FirebaseFirestore.instance.collection('attendance').doc('class1').get();

    // If the QR code matches the stored code, log attendance
    if (doc.exists && doc['code'] == scannedCode) {
      FirebaseFirestore.instance.collection('records').add({
        'studentId': studentId, // Store student ID
        'timestamp': Timestamp.now() // Log the current timestamp
      });
      print("Attendance Marked!"); // Feedback on success
    } else {
      print("Invalid Code!"); // Feedback on invalid scan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR Code")), // Top app bar
      body: MobileScanner(
        onDetect: (barcode) {
          // Trigger attendance marking when a QR code is detected
          _markAttendance(barcode.rawValue!);
        },
      ),
    );
  }
}
