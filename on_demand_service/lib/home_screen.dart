import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Welcome User",
          style: TextStyle(fontSize: 20, letterSpacing: 1),
        ),
      ),
    );
  }
}
