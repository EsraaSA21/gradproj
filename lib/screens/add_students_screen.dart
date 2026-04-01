import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:faceapp/screens/students_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:faceapp/screens/selfitips.dart';
import 'package:faceapp/config/api_config.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({super.key});

  @override
  State<AddStudentsScreen> createState() => AddStudentsScreenState();
}

class AddStudentsScreenState extends State<AddStudentsScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _faceScanned = false;
  bool _isSubmitting = false;

  final _studentNumberController = TextEditingController();
  final _fullNameArabicController = TextEditingController();
  final _fullNameEnglishController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedYear;
  String? _selectedMajor;
  String? _selectedCollege;

  Map<String, XFile> _capturedFaceImages = {};

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

  Future<void> _scanFace() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Selfitips()),
    );

    if (result != null && result['success'] == true) {
      final rawImages = result['images'];

      if (rawImages is Map) {
        _capturedFaceImages = rawImages.map(
          (key, value) => MapEntry(key.toString(), value as XFile),
        );
      } else {
        _capturedFaceImages = {};
      }

      setState(() {
        _faceScanned = _capturedFaceImages.isNotEmpty;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Face scanned successfully"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _registerFaceEmbedding({
    required String studentId,
    required Map<String, XFile> images,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/ai/register');

    final request = http.MultipartRequest('POST', uri)
      ..fields['student_id'] = studentId;

    for (final entry in images.entries) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          entry.value.path,
          filename: '${entry.key}.jpg',
        ),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    debugPrint('REGISTER STATUS: ${response.statusCode}');
    debugPrint('REGISTER BODY: $body');

    if (response.statusCode != 200 && response.statusCode != 201) {
      String message = 'Failed to save face embedding';

      try {
        final decoded = jsonDecode(body);
        if (decoded is Map && decoded['detail'] != null) {
          message = decoded['detail'].toString();
        }
      } catch (_) {}

      throw Exception(message);
    }
  }

  int? _mapYearToLevel(String? value) {
    switch (value) {
      case 'First Year':
        return 1;
      case 'Second Year':
        return 2;
      case 'Third Year':
        return 3;
      case 'Fourth Year':
        return 4;
      case 'Fifth Year':
        return 5;
      default:
        return null;
    }
  }

  String? _validateStudentNumber(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return "This field is required";
    if (v.length != 9) return "Must be exactly 9 digits";
    return null;
  }

  String? _validateRequired(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return "This field is required";
    return null;
  }

  String? _validatePhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return "This field is required";
    if (v.length != 10) return "Phone number must be 10 digits";
    if (!(v.startsWith('059') || v.startsWith('056'))) {
      return "Phone must start with 059 or 056";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(v)) {
      return "Enter a valid email address";
    }

    return null;
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;

    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    final bool isFaceValid = _faceScanned && _capturedFaceImages.isNotEmpty;

    if (!isFormValid || !isFaceValid) {
      String message = "";

      if (!isFormValid && !isFaceValid) {
        message = "Please fill all fields and scan your face";
      } else if (!isFormValid) {
        message = "Please fill all required fields correctly";
      } else if (!isFaceValid) {
        message = "Please scan your face";
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
      return;
    }

    final int? yearLevel = _mapYearToLevel(_selectedYear);
    if (yearLevel == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid academic year"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/students');

      final payload = {
        "student_no": _studentNumberController.text.trim(),
        "full_name_en": _fullNameEnglishController.text.trim(),
        "faculty": _selectedCollege,
        "full_name_ar": _fullNameArabicController.text.trim(),
        "phone_number": _phoneController.text.trim(),
        "major": _selectedMajor,
        "year_level": yearLevel,
        "photo_url": null,
        
        
      };

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);

        if (body is! Map<String, dynamic> || body['id'] == null) {
          throw Exception('Student created but no student id returned');
        }

        final String studentId = body['id'].toString();

        await _registerFaceEmbedding(
          studentId: studentId,
          images: _capturedFaceImages,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Student and face embedding added successfully"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
        return;
      }

      String errorMessage = "Failed to add student";
      try {
        final body = jsonDecode(response.body);
        if (body is Map<String, dynamic> && body['detail'] != null) {
          errorMessage = body['detail'].toString();
        }
      } catch (_) {}

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connection error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 600;
            final double contentWidth = isWide ? 430 : double.infinity;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
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
                            Flexible(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
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
                                  const Flexible(
                                    child: Text(
                                      "Add New Student",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
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
          },
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
                color: _faceScanned
                    ? const Color(0xFFE8F5E9)
                    : Colors.grey[200],
                border: Border.all(
                  color: _faceScanned ? Colors.green : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: _faceScanned
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 42,
                      )
                    : SizedBox(
                        width: 48,
                        height: 48,
                        child: CustomPaint(painter: _CornerBracketPainter()),
                      ),
              ),
            ),
          ),
          Center(
            child: InkWell(
              onTap: _scanFace,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 170,
                height: 60,
                margin: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A73E8), Color(0xFF0AA1DD)],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      _faceScanned ? "Rescan Face" : "Scan Face",
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
            validator: _validateStudentNumber,
          ),
          const SizedBox(height: 16),
          _buildLabel('Full Name (Arabic)', required: true),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _fullNameArabicController,
            hint: 'Enter full name in Arabic',
            textDirection: TextDirection.rtl,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          _buildLabel('Full Name (English)', required: true),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _fullNameEnglishController,
            hint: 'Enter full name in English',
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          _buildLabel('Phone Number', required: true),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _phoneController,
            hint: 'e.g., 059XXXXXXX',
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: _validatePhone,
          ),
          const SizedBox(height: 16),
          _buildLabel('Email Address'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _emailController,
            hint: 'student@university.edu',
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 8),
         
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
            validator: (value) => value == null || value.isEmpty
                ? 'Please select a college'
                : null,
            onChanged: (val) {
              setState(() {
                _selectedCollege = val;
                _selectedMajor = null;
              });
            },
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
            validator: (value) =>
                value == null || value.isEmpty ? 'Please select a major' : null,
            onChanged: (val) {
              setState(() {
                _selectedMajor = val;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildLabel('Academic Year', required: true),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedYear,
            hint: 'Select academic year',
            items: _years,
            validator: (value) => value == null || value.isEmpty
                ? 'Please select academic year'
                : null,
            onChanged: (val) {
              setState(() {
                _selectedYear = val;
              });
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A73E8),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade400,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
          shadowColor: const Color(0xFF1A73E8).withOpacity(0.4),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
            : const Row(
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
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
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
      style: const TextStyle(fontSize: 18, color: Color(0xFF1E293B)),
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8)),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(value: item, child: Text(item)),
          )
          .toList(),
    );
  }
}

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
  bool shouldRepaint(_CornerBracketPainter oldDelegate) => false;
}
