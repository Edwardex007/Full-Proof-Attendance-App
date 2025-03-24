import 'package:flutter/material.dart'; // Flutter UI components
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore for data operations
import 'package:mobile_scanner/mobile_scanner.dart'; // QR code scanner package

class QRScannerScreen extends StatefulWidget {
  final String studentId; // ID of the student
  final String studentName; // Name of the student
  final double latitude; // Latitude of student's location
  final double longitude; // Longitude of student's location

  // Constructor to initialize all required fields
  QRScannerScreen({
    required this.studentId,
    required this.studentName,
    required this.latitude,
    required this.longitude,
  });

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState(); // Create state for scanner
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _attendanceMarked = false; // Flag to prevent multiple submissions
  final TextEditingController _manualCodeController = TextEditingController(); // For manual code entry

  // Mark attendance by saving record in Firestore
  void _markAttendance(String className) async {
    await FirebaseFirestore.instance.collection('records').add({
      'studentId': widget.studentId,
      'studentName': widget.studentName,
      'latitude': widget.latitude,
      'longitude': widget.longitude,
      'className': className,
      'timestamp': Timestamp.now(),
    });

    setState(() {
      _attendanceMarked = true; // Set flag to prevent re-scanning
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Attendance marked successfully!")), // Show success message
    );
  }

  // Validate scanned or manually entered code
  void _processScan(String scannedCode) async {
    DocumentSnapshot attendanceDoc = await FirebaseFirestore.instance
        .collection('attendance')
        .doc('class1')
        .get();

    // Check if QR code is valid and not expired
    if (!attendanceDoc.exists || attendanceDoc['code'] != scannedCode) {
      _showMessage("❌ Incorrect or Expired QR Code!");
      return;
    }

    _markAttendance('class1'); // Proceed to mark attendance
  }

  // Manually entered code validation
  void _processManualEntry() {
    String enteredCode = _manualCodeController.text.trim();
    _processScan(enteredCode);
  }

  // Display a message in a snackbar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR Attendance")), // App bar title
      body: Column(
        children: [
          // QR code scanning area
          Expanded(
            child: MobileScanner(
              onDetect: (barcodeCapture) {
                if (!_attendanceMarked && barcodeCapture.barcodes.isNotEmpty) {
                  String? scannedCode = barcodeCapture.barcodes.first.rawValue;
                  if (scannedCode != null) {
                    _processScan(scannedCode);
                  }
                }
              },
            ),
          ),
          // Manual code entry field
          TextField(
            controller: _manualCodeController,
            decoration: InputDecoration(labelText: "Enter QR Code"),
          ),
          // Manual code submission button
          ElevatedButton(
            onPressed: _processManualEntry,
            child: Text("Submit Code"),
          ),
        ],
      ),
    );
  }
}
