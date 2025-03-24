// Import Flutter's material package for UI components.
import 'package:flutter/material.dart';
// Import Cloud Firestore package for database operations.
import 'package:cloud_firestore/cloud_firestore.dart';
// Import the custom Firestore service that handles Firestore operations.
import '.././firebase/firestore_service.dart';

// Define a stateless widget for displaying the teacher's attendance report.
class TeacherReportScreen extends StatelessWidget {
  // Class name for which the attendance report is generated.
  final String className;

  // Constructor that requires the className parameter.
  TeacherReportScreen({required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar displaying the attendance report title including the class name.
      appBar: AppBar(title: Text("Attendance Report - $className")),
      // Body of the screen built using a StreamBuilder to listen to Firestore updates.
      body: StreamBuilder<QuerySnapshot>(
        // Connect to the Firestore stream for attendance data using the custom service.
        stream: FirestoreService().getClassAttendance(className),
        builder: (context, snapshot) {
          // If the snapshot doesn't have data yet, show a loading spinner.
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Retrieve the list of documents (attendance records) from the snapshot.
          var records = snapshot.data!.docs;
          // Build a ListView to display the attendance records.
          return ListView.builder(
            // Set the number of items based on the number of records.
            itemCount: records.length,
            itemBuilder: (context, index) {
              // Convert each document's data to a Map for easier access.
              var record = records[index].data() as Map<String, dynamic>;
              // Create a ListTile for each record to display the student ID and timestamp.
              return ListTile(
                // Display the student ID from the record.
                title: Text("Student: ${record['studentId']}"),
                // Convert the Firestore Timestamp to a DateTime and display it.
                subtitle: Text("Time: ${record['timestamp'].toDate()}"),
              );
            },
          );
        },
      ),
    );
  }
}
