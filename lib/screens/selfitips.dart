import 'package:flutter/material.dart';
import 'package:faceapp/screens/face_scan.dart';

class Selfitips extends StatelessWidget {
  const Selfitips({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    bool isTablet = w > 600;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 231, 244, 255),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// HEADER
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: h * 0.03),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 15, 123, 211),
                        Colors.lightBlue,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Selfie Tips",
                    style: TextStyle(
                      fontSize: isTablet ? 28 : w * 0.062,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: h * 0.04),

                /// TEXTS
                Text(
                  "Follow these tips for best results",
                  style: TextStyle(
                    fontSize: isTablet ? 18 : w * 0.043,
                    color: Color.fromARGB(255, 60, 78, 87),
                  ),
                ),
                SizedBox(height: h * 0.005),
                Text(
                  "System Authentication Required",
                  style: TextStyle(
                    fontSize: isTablet ? 16 : w * 0.038,
                    color: Colors.blueGrey,
                  ),
                ),

                SizedBox(height: h * 0.03),

                /// TIPS
                tipCard(
                  context: context,
                  isTablet: isTablet,
                  icon: Icons.lightbulb_outline,
                  iconColor: Colors.orange,
                  bgColor: Colors.yellow.withOpacity(0.2),
                  title: "Good Lighting",
                  subtitle: "Ensure your face is well-lit and visible",
                ),
                tipCard(
                  context: context,
                  isTablet: isTablet,
                  icon: Icons.person_outline,
                  iconColor: Colors.pink,
                  bgColor: Colors.pink.withOpacity(0.15),
                  title: "Clear Face Visibility",
                  subtitle: "Keep hair away from your face and forehead",
                ),
                tipCard(
                  context: context,
                  isTablet: isTablet,
                  icon: Icons.remove_red_eye_outlined,
                  iconColor: Colors.purple,
                  bgColor: Colors.purple.withOpacity(0.15),
                  title: "Remove Accessories",
                  subtitle: "Take off glasses and face coverings",
                ),
                tipCard(
                  context: context,
                  isTablet: isTablet,
                  icon: Icons.phone_iphone,
                  iconColor: Colors.blue,
                  bgColor: Colors.blue.withOpacity(0.15),
                  title: "Hold Steady",
                  subtitle: "Keep your device still during scanning",
                ),

                SizedBox(height: h * 0.02),

                /// BUTTON
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FaceScanScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: isTablet ? w * 0.2 : w * 0.06,
                      vertical: h * 0.025,
                    ),
                    padding: EdgeInsets.symmetric(vertical: h * 0.02),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.lightBlueAccent, Colors.blue],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Start Face Scan",
                          style: TextStyle(
                            fontSize: isTablet ? 18 : w * 0.047,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: w * 0.02),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: isTablet ? 22 : w * 0.055,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget tipCard({
  required BuildContext context,
  required bool isTablet,
  required IconData icon,
  required Color iconColor,
  required Color bgColor,
  required String title,
  required String subtitle,
}) {
  final w = MediaQuery.of(context).size.width;

  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: isTablet ? w * 0.15 : w * 0.05,
      vertical: 8,
    ),
    padding: EdgeInsets.all(isTablet ? 20 : w * 0.04),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 12 : w * 0.03),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: isTablet ? 26 : w * 0.07,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 16 : w * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isTablet ? 14 : w * 0.036,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}