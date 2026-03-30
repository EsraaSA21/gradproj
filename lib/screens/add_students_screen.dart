import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:faceapp/screens/students_data.dart';
import 'package:faceapp/models/student.dart';
import 'dart:async';
import 'package:faceapp/screens/face_video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // 🔥 مهم

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({super.key});

  @override
  State<AddStudentsScreen> createState() => AddStudentsScreenState();
}

class AddStudentsScreenState extends State<AddStudentsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _faceScanned = false;
  String? _videoPath; // مسار الفيديو بعد التسجيل

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

  // ── فتح كاميرا الفيديو
  Future<void> _openFaceScan() async {
    final result = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => const FaceVideoScreen()),
    );

    if (result != null) {
      setState(() {
        _videoPath = result;
        _faceScanned = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text("Face scanned successfully!"),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _submitForm() async {
  
    bool isFormValid = _formKey.currentState!.validate();
    bool isFaceValid = _faceScanned;

    if (!isFormValid || !isFaceValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fill all fields and scan face ❗"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool _isLoading;
    setState(() => _isLoading = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://your-server.com/api/add-student',
        ), // 🔁 حط رابطك الحقيقي
      );

      request.files.add(
        await http.MultipartFile.fromPath('video', _videoPath!),
      );

      request.fields['nameEn'] = _fullNameEnglishController.text;
      request.fields['studentNumber'] = _studentNumberController.text;
      request.fields['faculty'] = _selectedCollege ?? "";
      request.fields['major'] = _selectedMajor ?? "";
      request.fields['year'] = _selectedYear ?? "";
      request.fields['nameAr'] = _fullNameArabicController.text;
      request.fields['phone'] = _phoneController.text;
      request.fields['email'] = _emailController.text;

      var response = await request.send();

      var responseData = await response.stream.bytesToString();

      var data = jsonDecode(responseData);

      setState(() => _isLoading = false);

      if (response.statusCode == 200 && data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Student added successfully ✅"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Failed to add student ❌"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Connection error "),
          backgroundColor: Colors.red,
        ),
      );

      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
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
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white24,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          "Add New Student",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
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
                      _buildFaceCard(),
                      const SizedBox(height: 16),
                      _buildPersonalInfoCard(),
                      const SizedBox(height: 16),
                      _buildAcademicInfoCard(),
                      const SizedBox(height: 24),
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

  // ── Face Card ────────────────────────────────────────────────────────
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

          // أيقونة الوجه — تتغير بعد الـ scan
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _faceScanned
                    ? Colors.green.withOpacity(0.1)
                    : Colors.grey[200],
                border: Border.all(
                  color: _faceScanned ? Colors.green : Colors.grey,
                  width: 2,
                ),
              ),
              child: _faceScanned
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 55,
                    )
                  : Center(
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: CustomPaint(painter: _CornerBracketPainter()),
                      ),
                    ),
            ),
          ),

          // Status text
          if (_faceScanned)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Center(
                child: Text(
                  "Face recorded ✓",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 4),

          // Scan Button
          Center(
            child: InkWell(
              onTap: _openFaceScan,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 160,
                height: 55,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _faceScanned
                        ? [Colors.green, Colors.teal]
                        : [const Color(0xFF1A73E8), const Color(0xFF0AA1DD)],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (_faceScanned
                                  ? Colors.green
                                  : const Color(0xFF1A73E8))
                              .withOpacity(0.35),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _faceScanned ? Icons.videocam : Icons.camera_alt,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _faceScanned ? "Re-scan" : "Scan Face",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
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
          _buildLabel('Full Name (English)', required: true),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _fullNameEnglishController,
            hint: 'Enter full name in English',
            validator: (v) =>
                v == null || v.isEmpty ? "This field is required" : null,
          ),
          const SizedBox(height: 16),
          _buildLabel('Phone Number', required: true),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _phoneController,
            hint: 'e.g., 059XXXXXXX',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) =>
                v == null || v.isEmpty ? "This field is required" : null,
          ),
          const SizedBox(height: 16),
          _buildLabel('Email Address', required: true),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _emailController,
            hint: 'student@university.edu',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return "This field is required";
              if (!v.contains('@'))
                return "Enter a valid email (must contain @)";
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
            onChanged: (val) => setState(() {
              _selectedCollege = val;
              _selectedMajor = null;
            }),
          ),
          const SizedBox(height: 16),
          _buildLabel('Major', required: true),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedMajor,
            hint: 'Select Major',
            items: _selectedCollege == null
                ? []
                : _majorsByCollege[_selectedCollege]!,
            onChanged: (val) => setState(() => _selectedMajor = val),
          ),
          const SizedBox(height: 16),
          _buildLabel('Academic Year'),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedYear,
            hint: 'Select academic year',
            items: _years,
            onChanged: (val) => setState(() => _selectedYear = val),
          ),
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

// Corner bracket painter
class _CornerBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const len = 12.0;
    canvas.drawLine(Offset(0, len), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(len, 0), paint);
    canvas.drawLine(Offset(size.width - len, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), paint);
    canvas.drawLine(
      Offset(0, size.height - len),
      Offset(0, size.height),
      paint,
    );
    canvas.drawLine(Offset(0, size.height), Offset(len, size.height), paint);
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
  bool shouldRepaint(_) => false;
}
