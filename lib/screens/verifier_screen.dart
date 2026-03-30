import 'package:faceapp/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:faceapp/screens/selfitips.dart';
import 'package:faceapp/screens/verification_profile.dart';
import 'package:faceapp/screens/settings.dart';


class Verifierscreen extends StatefulWidget {
  const Verifierscreen({super.key});

  @override
  State<Verifierscreen> createState() => _VerifierscreenState();
}

class _VerifierscreenState extends State<Verifierscreen> {
  String lastScan = "--:--";
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //  محاكاة جلب البيانات من الباك اند
  void fetchData() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      lastScan = "09:30 AM";
      status = "Verified";
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async {
      return false; // ❌ يمنع الرجوع نهائيًا
    },
    child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 244, 253),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔷 الهيدر
              Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 56, 165, 255),
                      Color.fromARGB(255, 3, 134, 194),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // النص
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back!",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          "Verifier",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 70),

                    //  أيقونة البروفايل + المينيو
                    GestureDetector(
                      
                      onTap: () async {
                        final selected = await showMenu<String>(
                        color: Colors.white,
                       
                          context: context,
                          position: RelativeRect.fromLTRB(300,170, 20, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                           
                          ),
                          items: [
                          
                            PopupMenuItem<String>(
                              value: 'profile',
                              child: Row(
                                children: [
                                  Icon(Icons.person_outlined, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Text("My Profile"),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'settings',
                              child: Row(
                                children: [
                                  Icon(Icons.settings_outlined, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Text("Settings"),
                                ],
                              ),
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem<String>(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(Icons.logout, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text(
                                    "Logout",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );

                        if (selected == 'profile') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        } else if (selected == 'settings') {
                          Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>SettingsScreen()),
                  );
                        } else if (selected == 'logout') {
                        Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => Secondscreen()),
  (route) => false,
);
                        }
                      },

                      child: Container(
                        margin: EdgeInsets.all(20),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 120),

              // 🔵 عنوان
              Text(
                "Scan to Continue",
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 6, 144, 213),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Selfitips()),
                  );
                },
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue, Color.fromARGB(255, 3, 175, 255)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 25,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.center_focus_strong,
                        color: Colors.white,
                        size: 90,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Face Scan",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              Row(
                children: [
                  InfoCard(
                    icon: Icons.access_time,
                    iconColor: Colors.blue,
                    title: "Last Scan",
                    value: lastScan,
                  ),

                  InfoCard(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    title: "Status",
                    value: status,
                    valueColor: status == "Verified"
                        ? Colors.green
                        : Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final Color? valueColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔵 الأيقونة
            Icon(icon, color: iconColor),

            SizedBox(width: 10),

            // 🔤 النصوص
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(color: Colors.grey)),
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
