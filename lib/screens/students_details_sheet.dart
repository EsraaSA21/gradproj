import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentDetailsSheet extends StatelessWidget {
 final Student student;
  const StudentDetailsSheet({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// 🔹 Header
          Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.blue, Color.fromARGB(255, 73, 188, 241)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: Colors.white),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.nameEn,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    student.studentNumber,
                    style: const TextStyle(color: Colors.grey,fontSize: 17),
                  ),
                ],
              ),

             
              
            ],
          ),

          const SizedBox(height: 20),

          /// 🔹 Email
          buildCard(Icons.email_outlined, "Email",
              student.email),

          const SizedBox(height: 12),

          /// 🔹 Phone
          buildCard(Icons.phone_outlined, "Phone",
              student.phone),

          const SizedBox(height: 12),

          /// 🔹 Academic Info
          buildCard(
            Icons.school_outlined,
            "Academic Info",
            "${student.faculty}\n${student.major}\n${student.year}",
          ),

          const SizedBox(height: 20),

          /// 🔹 Close Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 232, 233, 248),
                foregroundColor: Colors.black,
              ),
              child: const Text("Close",style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 78, 74, 74)
              ),),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue,),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,fontSize: 16,color: Color.fromARGB(255, 57, 57, 57))),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(color: Colors.grey,fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}