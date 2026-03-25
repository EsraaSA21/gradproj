import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RegistrarScreen extends StatelessWidget {
  const RegistrarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [Colors.blue, Color.fromARGB(255, 3, 175, 255)],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Register ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 4),

                      Row(
                        children: [
                          Icon(
                            PhosphorIcons.circle(),
                            size: 10,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Registrar",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  
                  Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0,4),
      )
    ],
  ),
  padding: EdgeInsets.all(12),
  child: Icon(
    PhosphorIcons.users(),
    color: Colors.blue,
    size: 35,
  ),
)
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(18),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  statCard(
                    icon: PhosphorIcons.users(),
                    title: "Total Students",
                    number: "1.2K",
                    gradientColors: [
                      Color.fromARGB(255, 66, 41, 255),
                      Color.fromARGB(255, 103, 76, 255),
                    ],
                  ),
                  statCard(
                    icon: PhosphorIcons.bell(),
                    title: "Today's Scans",
                    number: "350",
                    gradientColors: [
                      Color.fromARGB(255, 255, 25, 232),
                      Color.fromARGB(255, 144, 12, 164),
                    ],
                  ),
                  statCard(
                    icon: PhosphorIcons.checkCircle(),
                    title: "Success Rate",
                    number: "12.5K",
                    gradientColors: [
                      Color.fromARGB(255, 50, 193, 128),
                      Color.fromARGB(255, 24, 164, 20),
                    ],
                  ),
                  statCard(
                    icon: PhosphorIcons.clock(),
                    title: "Active Users",
                    number: "4.8",
                    gradientColors: [
                      Color.fromARGB(255, 235, 111, 22),
                      Color.fromARGB(255, 236, 65, 65),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text("Quick Actions", style: TextStyle(fontSize: 19)),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: quickActionCard(
                      icon: PhosphorIcons.userPlus(),
                      title: "Add Student",
                     onTap: () {
 /* Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddStudentScreen(),
    ),
  );*/
},
                    ),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: quickActionCard(
                      icon: PhosphorIcons.listBullets(),
                      title: "Students List",
                     onTap: () {
 /* Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => StudentsListScreen(),
    ),
  );*/
},
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 252, 255),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.blue),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(13),
                child: Text(
                  "Limited operational permissions. You can add or edit students, but you cannot delete them or modify system settings.",
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Color.fromARGB(255, 69, 69, 69),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget statCard({
  required IconData icon,
  required String title,
  required String number,
  required List<Color> gradientColors,
}) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// icon circle
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(icon, color: Colors.white),
        ),

        SizedBox(height: 12),

        /// title
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: const Color.fromARGB(255, 104, 104, 104),
          ),
        ),

        SizedBox(height: 4),

        /// number
        Text(
          number,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget quickActionCard({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      height: 110,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F7BFF), Color(0xFF6C5BFF)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white),
          ),

          SizedBox(height: 10),

          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 69, 69, 69),
            ),
          ),
        ],
      ),
    ),
  );
}
