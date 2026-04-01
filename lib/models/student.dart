class Student{
  final String studentNumber;
  final String nameEn;
  final String nameAr;
  final String phone;
  final String faculty;
  final String major;
  final String year;
  final String email;
   

  Student({
    required this.studentNumber,
    required this.nameEn,
    required this.nameAr,
    required this.phone,
    required this.faculty,
    required this.major,
    required this.year,
    required this.email,
   
  });
  factory Student.fromJson(Map<String, dynamic> json) {
  return Student(
    studentNumber: json['student_no'] ?? '',
    nameEn: json['full_name_en'] ?? '',
    nameAr: json['full_name_ar'] ?? '',
    phone: json['phone_number'] ?? '',
    faculty: json['faculty'] ?? '',
    major: json['major'] ?? '',
    year: json['year_level']?.toString() ?? '',
    email: json['email'] ?? '',
  );
}
Map<String, dynamic> toJson() {
  return {
    'student_number': studentNumber,
    'name_en': nameEn,
    'name_ar': nameAr,
    'phone': phone,
    'faculty': faculty,
    'major': major,
    'year': year,
    'email': email,
  };
}
}
