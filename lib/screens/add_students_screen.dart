import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:faceapp/screens/students_data.dart';
import 'package:faceapp/screens/student.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({super.key});

  @override
  State<AddStudentsScreen> createState() => AddStudentsScreenState();
}

class AddStudentsScreenState extends State<AddStudentsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _faceScanned =true;

  final _studentNumberController = TextEditingController();
  final _fullNameArabicController = TextEditingController();
  final _fullNameEnglishController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedYear;
  String? _selectedMajor;
  String? _selectedCollege;

  final Map<String, List<String>> _majorsByCollege = {
    'Engineering': [
      'Computer Engineering',
      'Civil Engineering',
      'Electrical Engineering',
      'Mechanical Engineering',
      'Chemical Engineering',
      'Architecture',
      'Industrial Engineering',
      
    ],
    'IT': [
      'Computer Science',
       'Information Systems', 
       'Software Engineering',
       'Cybersecurity',
       'Data Science',
       'Artificial Intelligence',
       'Network Engineering',
       
       ],
     'Business': [
      'Accounting', 
      'Marketing', 
      'Finance',
      'Human Resource Management',
      'International Business',
      'Entrepreneurship',
      'Supply Chain Management',
      ],
  };
  final List<String> _years = [
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year',
    'Fifth Year',
  ];

  @override
  void dispose() {
    _studentNumberController.dispose();
    _fullNameArabicController.dispose();
    _fullNameEnglishController.dispose();
    _phoneController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  void _scanFace() {
    setState(() {
      _faceScanned = true;
    });
    /*ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم مسح الوجه بنجاح'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );*/
  }

  void _submitForm() {
    // تحقق من الفورم
    bool isFormValid = _formKey.currentState!.validate();

    // تحقق من الوجه
    bool isFaceValid = _faceScanned;

    // إذا في أي خطأ
    if (!isFormValid || !isFaceValid) {
      String message = "";

      if (!isFormValid && !isFaceValid) {
        message = "Please fill all fields and scan your face";
      } else if (!isFormValid) {
        message = "Please fill all required fields";
      } else if (!isFaceValid) {
        message = "Please scan your face";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );

      return;
    }

 students.add(
  Student(
    nameEn: _fullNameEnglishController.text,
    studentNumber: _studentNumberController.text,
    faculty: _selectedCollege ?? "",
    major: _selectedMajor ?? "",
    year: _selectedYear ?? "",
    nameAr: _fullNameArabicController.text,
    phone: _phoneController.text,
    email: _emailController.text, 
    
  ),
);

Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 120,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Color(0xFF0AA1DD)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),

                        SizedBox(width: 20),

                        Text(
                          "Add New Student",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_add,
                        color: Colors.blue,
                        size: 27,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Face Embedding Card
                      _buildFaceCard(),
                      const SizedBox(height: 16),
                      // Personal Information Card
                      _buildPersonalInfoCard(),
                      const SizedBox(height: 16),
                      // Academic Information Card
                      _buildAcademicInfoCard(),
                      const SizedBox(height: 24),
                      // Submit Button
                      _buildSubmitButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Face Embedding',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(' *', style: TextStyle(color: Colors.red, fontSize: 20)),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.grey,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: CustomPaint(painter: _CornerBracketPainter()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: InkWell(
              onTap: _scanFace,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 150,
                height: 60,
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A73E8), Color(0xFF0AA1DD)],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),

                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text(
                      "scan face",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 20, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 20),
          // Student Number
          _buildLabel('Student Number', required: true),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _studentNumberController,
            hint: 'e.g., 202301001',

            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            validator: (v) {
              if (v == null || v.isEmpty) return "This field is required";
              if (v.length != 9) return 'Must be exactly 9 digits';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Full Name Arabic
          _buildLabel('Full Name (Arabic)', required: true),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _fullNameArabicController,
            hint: 'Enter full name in Arabic',
            textDirection: TextDirection.rtl,
            validator: (v) =>
                v == null || v.isEmpty ? "This field is required" : null,
          ),
          const SizedBox(height: 16),

          // Full Name English
          _buildLabel('Full Name (English)', required: true),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _fullNameEnglishController,
            hint: 'Enter full name in English',
            validator: (v) =>
                v == null || v.isEmpty ? "This field is required" : null,
          ),
          const SizedBox(height: 16),

          // Phone Number
          _buildLabel('Phone Number', required: true),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _phoneController,
            hint: 'e.g., 059XXXXXXX',
           keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (v) =>
                v == null || v.isEmpty ? "This field is required" : null,
          ),
          const SizedBox(height: 16),

          // Email
          _buildLabel('Email Address', required: true),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _emailController,
            hint: 'student@university.edu',
            keyboardType: TextInputType.emailAddress,
           validator: (v) {
  if (v == null || v.isEmpty) {
    return "This field is required";
  }
  if (!v.contains('@')) {
    return "Enter a valid email (must contain @)";
  }
  return null;
},
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Academic Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel('College', required: true),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedCollege,
            hint: 'Select College',
            items: _majorsByCollege.keys.toList(),
            onChanged: (val) {
              setState(() {
                _selectedCollege = val;

                // 🔥 مهم جدًا
                _selectedMajor = null; // تصفير التخصص
              });
            },
          ),
          const SizedBox(height: 16),

          // Major
          _buildLabel('Major', required: true),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedMajor,
            hint: 'Select Major',
            items: _selectedCollege == null
                ? []
                : _majorsByCollege[_selectedCollege]!,
            onChanged: (val) {
              setState(() {
                _selectedMajor = val;
              });
            },
          ),
          const SizedBox(height: 16),

          // Academic Year
          _buildLabel('Academic Year'),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedYear,
            hint: 'Select academic year',
            items: _years,
            onChanged: (val) => setState(() => _selectedYear = val),
          ),
          const SizedBox(height: 16),

          // Gender
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A73E8),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
          shadowColor: const Color(0xFF1A73E8).withOpacity(0.4),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_alt_1, size: 30),
            SizedBox(width: 8),
            Text(
              'Add Student',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
          ),
        ),
        if (required)
          const Text(' *', style: TextStyle(color: Colors.red, fontSize: 20)),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,

    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    TextDirection? textDirection,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      textDirection: textDirection,
      style: const TextStyle(fontSize: 20, color: Color(0xFF1E293B)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 18),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 18),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 1.5),
        ),
      ),
      style: const TextStyle(fontSize: 18, color: Color(0xFF1E293B)),
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8)),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
    );
  }
}

// Custom painter for corner bracket scan effect
class _CornerBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 12.0;

    // Top-left
    canvas.drawLine(Offset(0, len), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(len, 0), paint);
    // Top-right
    canvas.drawLine(Offset(size.width - len, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), paint);
    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height - len),
      Offset(0, size.height),
      paint,
    );
    canvas.drawLine(Offset(0, size.height), Offset(len, size.height), paint);
    // Bottom-right
    canvas.drawLine(
      Offset(size.width - len, size.height),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - len),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CornerBracketPainter oldDelegate) => false;
}
