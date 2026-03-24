import 'package:flutter/material.dart';
import 'package:faceapp/screens/secondscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  double opacity = 0;
  double scale = 0.7;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      
      setState(() {
        opacity = 1;
        scale = 1.5;
      });
    });
    Future.delayed(const Duration(seconds: 5), () {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Secondscreen(),
        ),
      );
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(seconds: 3),
          child: AnimatedScale(
            scale: scale,
            duration:  Duration(seconds: 3),
            child: SizedBox(
              height: 300,
              width: 250,
              child: Image.asset(
                "assets/Images/logo.jpeg"
              ),
            ),
          ),
        ),
      ),
    );
  }
}