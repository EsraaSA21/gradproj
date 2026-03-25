import 'package:faceapp/screens/login.dart';
import 'package:flutter/material.dart';

class Secondscreen extends StatelessWidget {
  const Secondscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Image.asset("assets/Images/logo.jpeg", width: 400, height: 500),
            SizedBox(height: 13),
            Text(
              "Face Recognition Access",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 18),
            Text(
              "Secure and efficient student identity verification using face recognition technology",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: const Color.fromARGB(255, 85, 85, 85),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 280,
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
