import 'package:flutter/material.dart';
import'package:faceapp/screens/face_scan.dart';


class Selfitips extends StatelessWidget {
  const Selfitips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 231, 244, 255),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 15, 123, 211),
                        Colors.lightBlue,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Selfie Tips",
                    style: TextStyle(
                      fontSize:25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Follow these tips for best results",
                  style: TextStyle(
                    fontSize: 17.5,
                    color: Color.fromARGB(255, 60, 78, 87),
                  ),
                ),
                Text(
                  "System Authentication Required ",
                  style: TextStyle(fontSize: 15.5, color: Colors.blueGrey),
                ),
                SizedBox(height: 25),
                tipCard(
                  icon: Icons.lightbulb_outline,
                  iconColor: Colors.orange,
                  bgColor: Colors.yellow.withOpacity(0.2),
                  title: "Good Lighting",
                  subtitle: "Ensure your face is well-lit and visible",
                ),
                tipCard(
                  icon: Icons.person_outline,
                  iconColor: Colors.pink,
                  bgColor: Colors.pink.withOpacity(0.15),
                  title: "Clear Face Visibility",
                  subtitle: "Keep hair away from your face and forehead",
                ),
                tipCard(
                  icon: Icons.remove_red_eye_outlined,
                  iconColor: Colors.purple,
                  bgColor: Colors.purple.withOpacity(0.15),
                  title: "Remove Accessories",
                  subtitle: "Take off glasses and face coverings",
                ),
                tipCard(
                  icon: Icons.phone_iphone,
                  iconColor: Colors.blue,
                  bgColor: Colors.blue.withOpacity(0.15),
                  title: "Hold Steady",
                  subtitle: "Keep your device still during scanning",
                ),
                const SizedBox(height: 20),
               InkWell(
  borderRadius: BorderRadius.circular(20),
  onTap: () {
   Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  FaceScanScreen(),
                            ),
   );
  },
  child: Container(
   margin: const EdgeInsets.symmetric( horizontal: 25, vertical: 20, ), 
   height: 70,
    width: double.infinity,
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
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),
        Icon(Icons.arrow_forward, color: Colors.white),
      ],
    ),
  ),
)
              ],
            ),
          ),
        ),
      );
    
  }
}

Widget tipCard({
  required IconData icon,
  required Color iconColor,
  required Color bgColor,
  required String title,
  required String subtitle,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    padding: EdgeInsets.all(16),
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
        /// مربع الأيقونة
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),

        SizedBox(width: 14),

        /// النصوص
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14.6, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
 