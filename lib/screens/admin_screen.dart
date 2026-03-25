import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Screen"),
      ),
      body: Center(
        child: Text("Welcome, Admin!"),
      ),
    );
  }
}