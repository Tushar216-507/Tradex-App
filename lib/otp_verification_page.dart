import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // For Ticker
import 'dart:async';

class OtpVerificationPage extends StatefulWidget {
  final VoidCallback onVerified; // The callback for when OTP is verified

  const OtpVerificationPage({super.key, required this.onVerified});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  int _secondsLeft = 60;
 // late Ticker _ticker; // Ticker for countdown timer

  // Add this at the top

  late Timer _timer; // Replace Ticker with Timer

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer instead of disposing ticker
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("OTP Verification", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter OTP",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _otpController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "OTP",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // OTP verification logic here
                widget
                    .onVerified(); // Trigger the callback when OTP is verified
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Verify OTP"),
            ),
            SizedBox(height: 20),
            Text(
              _secondsLeft > 0
                  ? "Resend OTP in $_secondsLeft seconds"
                  : "Resend OTP",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            _secondsLeft == 0
                ? ElevatedButton(
                  onPressed: () {
                    // Resend OTP logic
                    setState(() {
                      _secondsLeft = 60; // Reset countdown
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Resend OTP"),
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}
