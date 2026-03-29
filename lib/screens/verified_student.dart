// ══════════════════════════════════════════════════════════════════════
class VerifiedStudent {
  final String name;
  final String studentId;
  final String faculty;
  final String major;
  final String yearLevel;
  final String verificationTime;
  final String status;
  final String date;

  VerifiedStudent({
    required this.name,
    required this.studentId,
    required this.faculty,
    required this.major,
    required this.yearLevel,
    required this.verificationTime,
    required this.status,
    required this.date,
  });

  // ✏️ غيّر الـ keys حسب الـ response من الباك اند
  factory VerifiedStudent.fromJson(Map<String, dynamic> json) {
    return VerifiedStudent(
      name:             json['full_name']          ?? json['name']     ?? '',
      studentId:        json['student_id']          ?? json['id']       ?? '',
      faculty:          json['faculty']             ?? '',
      major:            json['major']               ?? '',
      yearLevel:        json['year_level']          ?? json['year']     ?? '',
      verificationTime: json['verification_time']   ?? '',
      status:           json['status']              ?? 'Authorized',
      date:             json['date']                ?? '',
    );
  }
}