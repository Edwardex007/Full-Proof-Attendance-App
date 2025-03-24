import 'package:flutter/material.dart'; // Flutter UI widgets
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore package

class AttendanceHistoryScreen extends StatelessWidget {
  final String studentId; // Unique identifier for the student

  // Constructor to receive studentId
  AttendanceHistoryScreen({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance History")), // App bar title
      body: StreamBuilder<QuerySnapshot>(
        // Stream from Firestore to listen to records for the specific student
        stream: FirebaseFirestore.instance
            .collection('records')
            .where('studentId', isEqualTo: studentId)
            .snapshots(),
        builder: (context, snapshot) {
          // Show loading spinner while waiting for data
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var records = snapshot.data!.docs; // List of attendance records
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              var record = records[index].data() as Map<String, dynamic>; // Extract document data
              return ListTile(
                title: Text("Class: ${record['className']}"), // Class name
                subtitle: Text("Date: ${record['timestamp'].toDate()}"), // Timestamp converted to date
              );
            },
          );
        },
      ),
    );
  }
}
