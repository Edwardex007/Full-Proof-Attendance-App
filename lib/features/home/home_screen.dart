import 'package:flutter/material.dart'; // Flutter material design widgets
import 'package:provider/provider.dart'; // State management for accessing AuthService
import '../../core/services/auth_service.dart'; // Custom authentication service
import '../student/student_info_screen.dart'; // Student info entry screen
import '../staff/attendance_report_screen.dart'; // Teacher's report screen
import '../attendance/qr_code_generator.dart'; // QR code generation screen for teachers

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context); // Access authentication state
    final user = authService.user; // Get current Firebase user
    final isTeacher = user?.email?.endsWith('@school.edu') ?? false; // Identify teacher by email domain
    final isStudent = !isTeacher; // All others are considered students

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.school, color: Colors.white), // School icon in app bar
            SizedBox(width: 8),
            Text("Attendance App"), // App title
          ],
        ),
        backgroundColor: Colors.orange, // App bar theme color
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.orange), // User avatar
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white), // Logout button
            onPressed: () {
              authService.signOut(); // Sign out the user
              Navigator.pushReplacementNamed(context, '/'); // Redirect to login
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16), // Padding around content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome header message
            Text(
              "Welcome, ${user?.displayName ?? 'User'} 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Dashboard grid buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  if (isStudent)
                    _buildOptionCard(
                      context,
                      Icons.check_circle_outline,
                      "Start Attendance",
                      StudentInfoScreen(),
                    ),
                  if (isTeacher)
                    _buildOptionCard(
                      context,
                      Icons.qr_code,
                      "Generate QR Code",
                      QRCodeGenerator(className: 'class1'),
                    ),
                  if (isTeacher)
                    _buildOptionCard(
                      context,
                      Icons.analytics,
                      "View Reports",
                      AttendanceReportScreen(className: 'class1'),
                    ),
                  _buildOptionCard(context, Icons.history, "Attendance History", null), // Placeholder
                  _buildOptionCard(context, Icons.settings, "Settings", null), // Placeholder
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating action button (can be configured later)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  // Helper method to generate a grid card with icon and label
  Widget _buildOptionCard(BuildContext context, IconData icon, String title, Widget? page) {
    return GestureDetector(
      onTap: () {
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page)); // Navigate to new page
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3), // Drop shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.orange), // Main icon
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Label below icon
            ),
          ],
        ),
      ),
    );
  }
}
