import 'package:flutter/material.dart';
import '/features/login/login_screen.dart'; // Login screen widget
import '/features/registration/registration_screen.dart'; // Registration screen widget
import '/features/home/home_screen.dart'; // Home dashboard screen
import '/features/student/student_info_screen.dart'; // Student info entry screen
import '/features/student/qr_scanner_screen.dart'; // QR code scanner screen for students
import '/features/staff/staff_dashboard.dart'; // Dashboard screen for staff users
import '/features/attendance/qr_code_generator.dart'; // QR code generator screen for teachers
import '/features/staff/attendance_report_screen.dart'; // Attendance report screen for teachers

// Static routes for navigation using named paths
final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => LoginScreen(), // Root route opens login screen
  '/register': (context) => RegistrationScreen(), // Route to registration page
  '/home': (context) => HomeScreen(), // Route to home screen after login
  '/studentInfo': (context) => StudentInfoScreen(), // Route to student info input screen
  '/staffDashboard': (context) => StaffDashboard(), // Route to staff dashboard
  '/qrGenerator': (context) => QRCodeGenerator(className: 'class1'), // Teacher QR generator screen with static class
  '/attendanceReport': (context) => AttendanceReportScreen(className: 'class1'), // Attendance report screen for given class
};

// Dynamically handles routes that require arguments at runtime
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  if (settings.name == '/qrScanner') {
    final args = settings.arguments as Map<String, dynamic>; // Extract arguments from route

    // Return a material page route for QR scanner with student data
    return MaterialPageRoute(
      builder: (context) => QRScannerScreen(
        studentId: args['studentId'],
        studentName: args['studentName'],
        latitude: args['latitude'],
        longitude: args['longitude'],
      ),
    );
  }
  return null; // Return null for unknown routes to prevent errors
}
