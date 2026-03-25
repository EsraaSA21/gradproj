import 'package:flutter/material.dart';
class RegistrarScreen extends StatelessWidget {
  const RegistrarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Screen"),
      ),
      body: Center(
        child: Text("Welcome, Registrar!"),
      ),
    );
  }
}