import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔵 HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 56, 165, 255),
                    Color.fromARGB(255, 3, 134, 194),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
             
              
              child: Column(
                 
                children: [
                 
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔹 Username
                  const Text(
                    "Ahmed",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // 🔹 ID
                  const Text(
                    "2024-1001",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          

            SizedBox(height: 20),
Container(
  margin: const EdgeInsets.symmetric(horizontal: 15),
  padding: const EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 10,
      ),
    ],
  ),

  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Row(
        children: [
          Container(
  padding: EdgeInsets.all(6),
  decoration: BoxDecoration(
    color: Colors.blue.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Icon(Icons.mail, size: 20, color: Colors.blue),
),

          const SizedBox(width: 10),

          Text(
            "Contact Information",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ],    
      )
      ,
      

      const SizedBox(height: 10),

      Divider(color: const Color.fromARGB(255, 197, 195, 195)),

      const SizedBox(height: 10),

      // 🔹 البيانات
      InfoRow(
        
        icon: Icons.person_outlined,
        title: "Full Name",
        value: "Ahmed Hassan",
      ),

     Divider(color: const Color.fromARGB(255, 197, 195, 195)),

      InfoRow(
        icon: Icons.email_outlined,
        title: "Email",
        value: "ahmed@email.com",
      ),

     Divider(color: const Color.fromARGB(255, 197, 195, 195)),

      InfoRow(
        icon: Icons.phone_outlined,
        title: "Phone Number",
        value: "+970 599 123 456",
      ),
    ],
  ),
)
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////
// 🔹 INFO ROW
//////////////////////////////////////////////////////
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
  padding: EdgeInsets.all(6),
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 165, 171, 177).withOpacity(0.1),
    borderRadius: BorderRadius.circular(10),
  ),
  child:Icon(icon, color: const Color.fromARGB(255, 49, 50, 52)),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Color.fromARGB(255, 133, 133, 133))),

                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
