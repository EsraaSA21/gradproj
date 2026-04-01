import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:faceapp/models/student.dart';
import 'package:faceapp/screens/students_details_sheet.dart';
import 'package:faceapp/config/api_config.dart';
class StudentsListScreen extends StatefulWidget {
  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
List<Student> allStudents = [];
List<Student> filteredStudents = [];
TextEditingController searchController = TextEditingController();
bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }
Future<void> fetchStudents() async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/students'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Student> loaded = data.map((e) => Student.fromJson(e)).toList();
      setState(() {
        allStudents = loaded;
        filteredStudents = loaded;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  } catch (e) {
    setState(() => isLoading = false);
  }
}
void searchStudent(String query) {
  final results = allStudents.where((student) {
    return student.nameEn.toLowerCase().contains(query.toLowerCase()) ||
        student.studentNumber.contains(query);
  }).toList();

  setState(() {
    filteredStudents = results;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: CustomScrollView(

        slivers: [

          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 130,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 56, 165, 255),
                      const Color.fromARGB(255, 3, 134, 194),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔙 BACK + TITLE
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Students List",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 🔍 SEARCH
                    TextField(
                      controller: searchController,
                      onChanged: searchStudent,
                      decoration: InputDecoration(
                        hintText: "Search by name, ID...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
isLoading
    ? const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      )
          // 📋 LIST
          :filteredStudents.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      "No students yet",
                      style: TextStyle(fontSize: 23, color: Colors.grey),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final s = filteredStudents[index];

                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => StudentDetailsSheet(
                            student: s, //  نمرر بيانات الطالب
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Color.fromARGB(255, 139, 197, 225),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.nameEn,
                                    style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      
                                    ),
                                  ),

                                  Text(
                                    "${s.studentNumber}",
                                    style: TextStyle(fontSize: 16,color: const Color.fromARGB(255, 116, 110, 110)),
                                  ),

                                  Row(
                                    children: [
                                      Icon(Icons.school, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        s.faculty,
                                        style: TextStyle(fontSize: 16,color: const Color.fromARGB(255, 116, 110, 110)),
                                      ),
                                    ],
                                  ),
                                 
                                      Text(
                                        "${s.major} • ${s.year}",
                                        style: TextStyle(fontSize: 16,color: const Color.fromARGB(255, 116, 110, 110),)
                                      ),
                                    ],
                                  
                                
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: filteredStudents.length),
                ),
        ],
      ),
    );
  }
}
