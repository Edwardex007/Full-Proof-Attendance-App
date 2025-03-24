import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> markAttendance(String studentId, String className) async {
    String currentCode = (await _db.collection('attendance').doc(className).get()).data()?['code'] ?? '';

    if (currentCode.isNotEmpty) {
      await _db.collection('records').add({
        'studentId': studentId,
        'className': className,
        'timestamp': Timestamp.now(),
      });
    }
  }

  Stream<QuerySnapshot> getClassAttendance(String className) {
    return _db.collection('records').where('className', isEqualTo: className).snapshots();
  }

  Future<List<Map<String, dynamic>>> getDetailedClassReport(String className) async {
    QuerySnapshot snapshot = await _db.collection('records').where('className', isEqualTo: className).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
