import 'package:flutter/material.dart'; // Flutter material widgets
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore database
import 'dart:math' show cos, sqrt, asin; // For Haversine distance calculation

class AttendanceReportScreen extends StatefulWidget {
  final String className; // Class name used to fetch attendance records

  const AttendanceReportScreen({required this.className});

  @override
  _AttendanceReportScreenState createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  final double classLatitude = 51.5891598790914; // Latitude of the class location
  final double classLongitude = -3.3294197330246593; // Longitude of the class location

  String _sortOption = 'Time'; // Default sort option

  // Haversine formula to calculate distance between two geo points in km
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Report")), // Title bar
      body: Column(
        children: [
          // Dropdown for sorting options
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _sortOption,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'A-Z', child: Text("Sort: A-Z")),
                DropdownMenuItem(value: 'Z-A', child: Text("Sort: Z-A")),
                DropdownMenuItem(value: 'Closest', child: Text("Sort: Closest")),
                DropdownMenuItem(value: 'Furthest', child: Text("Sort: Furthest")),
                DropdownMenuItem(value: 'Time', child: Text("Sort: Time")),
              ],
              onChanged: (value) {
                setState(() {
                  _sortOption = value!;
                });
              },
            ),
          ),
          // Main content displaying attendance records
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('records')
                  .where('className', isEqualTo: widget.className)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No attendance records found."));
                }

                List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                // Map records to enriched format with distance calculation
                List<Map<String, dynamic>> records = docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;

                  String studentName = data['studentName'] ?? "Unknown Student";
                  String studentId = data['studentId'] ?? "Unknown ID";
                  DateTime timestamp = (data['timestamp'] as Timestamp).toDate();

                  double? lat = (data['latitude'] as num?)?.toDouble();
                  double? lon = (data['longitude'] as num?)?.toDouble();
                  double? distance = (lat != null && lon != null)
                      ? calculateDistance(classLatitude, classLongitude, lat, lon)
                      : null;

                  return {
                    'name': studentName,
                    'id': studentId,
                    'timestamp': timestamp,
                    'latitude': lat,
                    'longitude': lon,
                    'distance': distance,
                  };
                }).toList();

                // Apply sorting
                switch (_sortOption) {
                  case 'A-Z':
                    records.sort((a, b) => a['name'].compareTo(b['name']));
                    break;
                  case 'Z-A':
                    records.sort((a, b) => b['name'].compareTo(a['name']));
                    break;
                  case 'Closest':
                    records.sort((a, b) =>
                        (a['distance'] ?? double.infinity).compareTo(b['distance'] ?? double.infinity));
                    break;
                  case 'Furthest':
                    records.sort((a, b) =>
                        (b['distance'] ?? 0).compareTo(a['distance'] ?? 0));
                    break;
                  case 'Time':
                  default:
                    records.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
                }

                // Display each record as a card with location and distance info
                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    final hasLocation = record['latitude'] != null && record['longitude'] != null;
                    final distance = record['distance'] ?? double.infinity;
                    final distanceStr = distance != double.infinity ? distance.toStringAsFixed(2) : "Unknown";

                    Color dotColor;
                    if (distance <= 1.0) {
                      dotColor = Colors.green;
                    } else if (distance <= 2.0) {
                      dotColor = Colors.orange;
                    } else {
                      dotColor = Colors.red;
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Icon(Icons.circle, size: 16, color: dotColor), // Proximity indicator
                        title: Text("${record['name']} (${record['id']})"), // Student name and ID
                        subtitle: hasLocation
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("📍 ${record['latitude']}, ${record['longitude']}"),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: (distance / 2.0).clamp(0.0, 1.0), // Scaled progress (0–2 km range)
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(dotColor),
                              minHeight: 6,
                            ),
                            const SizedBox(height: 4),
                            Text("📏 Distance: $distanceStr km"), // Show distance from class
                          ],
                        )
                            : const Text("📍 Location Unknown"), // Shown if no location available
                        trailing: Text(record['timestamp'].toString().split(".").first), // Timestamp of attendance
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
