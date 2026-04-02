import 'package:faceapp/screens/face_scan.dart';
import 'package:faceapp/screens/registrar_screen.dart';
import 'package:faceapp/screens/verification_failed.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:faceapp/screens/selfitips.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrarScreen()
    );
  }
}

