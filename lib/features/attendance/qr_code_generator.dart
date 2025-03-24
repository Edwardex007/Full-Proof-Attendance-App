import 'dart:async'; // Provides Timer for periodic updates
import 'dart:math'; // Provides Random for code generation
import 'package:flutter/material.dart'; // Flutter UI package
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore integration
import 'package:qr_flutter/qr_flutter.dart'; // Package to generate QR codes visually

class QRCodeGenerator extends StatefulWidget {
  final String className; // Name of the class this QR code is tied to

  QRCodeGenerator({required this.className});

  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState(); // Create state for the widget
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  String _currentCode = ""; // Holds the current QR/manual code
  Timer? _timer; // Timer for updating QR code periodically

  @override
  void initState() {
    super.initState();
    _generateNewCode(); // Generate initial QR code
    _startTimer(); // Start periodic QR refresh
  }

  // Start a timer that updates the code every 30 seconds
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _generateNewCode(); // Refresh code each interval
    });
  }

  // Generate a new random code and push it to Firestore
  void _generateNewCode() {
    String newCode = _generateRandomCode(); // Generate 6-digit random code
    int expirationTime = DateTime.now().add(Duration(seconds: 30)).millisecondsSinceEpoch;

    setState(() {
      _currentCode = newCode; // Update the UI with the new code
    });

    print("🔥 New Code Generated: $newCode (Expires at $expirationTime)");

    // Save the code and expiration to Firestore under the class document
    FirebaseFirestore.instance.collection('attendance').doc(widget.className).set({
      'code': newCode,
      'expiresAt': expirationTime,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((_) {
      print("✅ Firestore Updated Successfully with new QR Code: $newCode");
    }).catchError((error) {
      print("❌ Firestore Update Failed: $error");
    });
  }

  // Create a 6-digit numeric code using Random
  String _generateRandomCode() {
    final random = Random();
    return List.generate(6, (index) => random.nextInt(10)).join(); // Example: "304872"
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR & Manual Code")), // App bar title
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentCode.isNotEmpty) ...[
              QrImageView(
                data: _currentCode, // Data to encode in QR
                version: QrVersions.auto,
                size: 200.0,
              ),
              SizedBox(height: 16),
              Text(
                "Manual Code: $_currentCode", // Display the current manual code
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Code changes every 30 seconds", // Timer notice
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
