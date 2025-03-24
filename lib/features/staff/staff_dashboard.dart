import 'package:flutter/material.dart'; // Flutter UI widgets
import 'package:flutterapp/features/attendance/qr_code_generator.dart'; // Real-time QR code generator screen
import 'attendance_report_screen.dart'; // Screen to view class attendance records

class StaffDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Staff Dashboard")), // Top app bar with title
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around buttons
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Make buttons full width
          children: [
            // Button to navigate to QR code generator
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodeGenerator(className: 'Math101'),
                  ),
                );
              },
              child: Text("Create Attendance Session"), // Button label
            ),
            SizedBox(height: 16), // Space between buttons
            // Button to navigate to attendance report screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceReportScreen(className: 'Math101'),
                  ),
                );
              },
              child: Text("View Attendance Report"), // Button label
            ),
          ],
        ),
      ),
    );
  }
}
