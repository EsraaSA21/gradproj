import 'package:faceapp/screens/login.dart';
import 'package:flutter/material.dart';

class Secondscreen extends StatelessWidget {
  const Secondscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1000;
    final bool isDesktop = screenWidth >= 1000;

    final double imageWidth = isMobile
        ? screenWidth * 0.82
        : isTablet
            ? 320
            : 280;

    final double titleFontSize = isMobile
        ? 20
        : isTablet
            ? 23
            : 26;

    final double descFontSize = isMobile
        ? 16
        : isTablet
            ? 17
            : 18;

    final double buttonWidth = isMobile
        ? screenWidth * 0.72
        : isTablet
            ? 280
            : 300;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                   "assets/Images/logo.jpeg",
                    width: imageWidth,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: isDesktop ? 8 : 12),
                  Text(
                    "Face Recognition Access",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 12 : 4,
                    ),
                    child: Text(
                      "Secure and efficient student identity verification using face recognition technology",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: descFontSize,
                        color: const Color.fromARGB(255, 85, 85, 85),
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: isDesktop ? 24 : 22),
                  Container(
                    width: buttonWidth,
                    height: isMobile ? 54 : 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: isMobile ? 18 : 19,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}