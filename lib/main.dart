import 'package:faceapp/screens/add_students_screen.dart';
import 'package:faceapp/screens/face_scan.dart';
import 'package:faceapp/screens/registrar_screen.dart';
import 'package:faceapp/screens/settings.dart';
import 'package:faceapp/screens/verification_failed.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:faceapp/screens/selfitips.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized(); 
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  runApp(const MyApp());
  
  FlutterNativeSplash.remove(); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SettingsScreen(),
    );
  }
}
