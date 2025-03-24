// Import necessary Flutter packages and other screens used in the dashboard.
import 'package:flutter/material.dart';
import 'attendance_history_screen.dart'; // Screen for viewing attendance history.
import 'qr_scanner_screen.dart';         // Screen for scanning QR codes.
import 'student_info_screen.dart';        // Screen for displaying student information (import confirmed).

// Define a StatelessWidget for the Student Dashboard.
class StudentDashboard extends StatelessWidget {
  // Declare the properties that hold student and location information.
  final String studentId;
  final String studentName;
  final double latitude;
  final double longitude;

  // Constructor for the StudentDashboard widget.
  // All parameters are required and are passed during widget instantiation.
  StudentDashboard({
    required this.studentId,
    required this.studentName, // Student's name is provided.
    required this.latitude,    // Latitude coordinate is provided.
    required this.longitude,   // Longitude coordinate is provided.
  });

  // The build method returns a widget tree that describes the layout of the dashboard.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar at the top of the screen with the title "Student Dashboard".
      appBar: AppBar(title: Text("Student Dashboard")),
      // The body of the scaffold, padded on all sides.
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add 16 pixels of padding around the content.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children to occupy full width.
          children: [
            // Elevated button to navigate to the QR Scanner screen.
            ElevatedButton(
              onPressed: () {
                // Navigate to QRScannerScreen and pass along the student's info and location.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScannerScreen(
                      studentId: studentId,
                      studentName: studentName,
                      latitude: latitude,
                      longitude: longitude,
                    ),
                  ),
                );
              },
              child: Text("Scan QR Code"), // Label on the button.
            ),
            SizedBox(height: 16), // Spacer to separate the buttons.
            // Elevated button to navigate to the Attendance History screen.
            ElevatedButton(
              onPressed: () {
                // Navigate to AttendanceHistoryScreen and pass the student's ID.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceHistoryScreen(studentId: studentId),
                  ),
                );
              },
              child: Text("View Attendance History"), // Label on the button.
            ),
          ],
        ),
      ),
    );
  }
}
