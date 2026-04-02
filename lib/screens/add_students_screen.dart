import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:faceapp/screens/selfitips.dart';
import 'package:faceapp/config/api_config.dart';

// ══════════════════════════════════════════════════════════════════════
// BREAKPOINTS HELPER
// ══════════════════════════════════════════════════════════════════════
class _Responsive {
  final double w;
  final double h;

  _Responsive(BuildContext context)
      : w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;

  bool get isSmall  => w < 360;
  bool get isMedium => w < 480;
  bool get isLarge  => w < 768;
  bool get isTablet => w >= 768;

  double dp(double size) {
    if (isSmall)  return size * 0.85;
    if (isMedium) return size * 1.0;
    if (isLarge)  return size * 1.1;
    return size * 1.25;
  }

  double fs(double size) {
    if (isSmall)  return size * 0.88;
    if (isMedium) return size * 1.0;
    if (isLarge)  return size * 1.08;
    return size * 1.2;
  }

  double get contentWidth {
    if (isTablet) return w * 0.65;
    return double.infinity;
  }

  double get horizontalPadding {
    if (isTablet) return w * 0.03;
    if (isLarge)  return w * 0.05;
    return w * 0.04;
  }

  double get headerHeight {
    if (isSmall)  return 100.0;
    if (isMedium) return 120.0;
    if (isLarge)  return 130.0;
    return 150.0;
  }

  double get faceCircleSize {
    if (isSmall)  return 90.0;
    if (isMedium) return 110.0;
    if (isLarge)  return 120.0;
    return 140.0;
  }

  double get faceIconSize {
    if (isSmall)  return 34.0;
    if (isMedium) return 42.0;
    return 50.0;
  }

  double get scanButtonWidth {
    if (isSmall)  return 150.0;
    if (isMedium) return 170.0;
    if (isLarge)  return 185.0;
    return 210.0;
  }

  double get scanButtonHeight {
    if (isSmall)  return 52.0;
    if (isMedium) return 60.0;
    return 66.0;
  }

  double get submitButtonHeight {
    if (isSmall)  return 46.0;
    if (isMedium) return 52.0;
    return 58.0;
  }

  double get cardPadding {
    if (isSmall)  return 14.0;
    if (isMedium) return 20.0;
    return 24.0;
  }

  double get cardRadius {
    if (isSmall)  return 12.0;
    if (isMedium) return 16.0;
    return 20.0;
  }

  double get fieldVerticalPadding {
    if (isSmall)  return 10.0;
    if (isMedium) return 13.0;
    return 15.0;
  }
}

// ══════════════════════════════════════════════════════════════════════
// ADD STUDENTS SCREEN
// ══════════════════════════════════════════════════════════════════════
class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({super.key});

  @override
  State<AddStudentsScreen> createState() => AddStudentsScreenState();
}

class AddStudentsScreenState extends State<AddStudentsScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _faceScanned   = false;
  bool _isSubmitting  = false;

  final _studentNumberController   = TextEditingController();
  final _fullNameArabicController  = TextEditingController();
  final _fullNameEnglishController = TextEditingController();
  final _phoneController           = TextEditingController();
  final _emailController           = TextEditingController();

  String? _selectedYear;
  String? _selectedMajor;
  String? _selectedCollege;

  Map<String, XFile> _capturedFaceImages = {};

  final Map<String, List<String>> _majorsByCollege = {
    'Engineering': [
      'Computer Engineering', 'Civil Engineering', 'Electrical Engineering',
      'Mechanical Engineering', 'Chemical Engineering', 'Architecture',
      'Industrial Engineering',
    ],
    'IT': [
      'Computer Science', 'Information Systems', 'Software Engineering',
      'Cybersecurity', 'Data Science', 'Artificial Intelligence',
      'Network Engineering',
    ],
    'Business': [
      'Accounting', 'Marketing', 'Finance', 'Human Resource Management',
      'International Business', 'Entrepreneurship', 'Supply Chain Management',
    ],
  };

  final List<String> _years = [
    'First Year', 'Second Year', 'Third Year', 'Fourth Year', 'Fifth Year',
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

      setState(() => _faceScanned = _capturedFaceImages.isNotEmpty);

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
    final uri     = Uri.parse('${ApiConfig.baseUrl}/ai/register');
    final request = http.MultipartRequest('POST', uri)
      ..fields['student_id'] = studentId;

    for (final entry in images.entries) {
      request.files.add(await http.MultipartFile.fromPath(
        'files', entry.value.path,
        filename: '${entry.key}.jpg',
      ));
    }

    final response = await request.send();
    final body     = await response.stream.bytesToString();

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
      case 'First Year':  return 1;
      case 'Second Year': return 2;
      case 'Third Year':  return 3;
      case 'Fourth Year': return 4;
      case 'Fifth Year':  return 5;
      default:            return null;
    }
  }

  String? _validateStudentNumber(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty)     return "This field is required";
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
    if (v.isEmpty)      return "This field is required";
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
    if (!emailRegex.hasMatch(v)) return "Enter a valid email address";
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
      } else {
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

    setState(() => _isSubmitting = true);

    try {
      final uri     = Uri.parse('${ApiConfig.baseUrl}/students');
      final payload = {
        "student_no":   _studentNumberController.text.trim(),
        "full_name_en": _fullNameEnglishController.text.trim(),
        "faculty":      _selectedCollege,
        "full_name_ar": _fullNameArabicController.text.trim(),
        "phone_number": _phoneController.text.trim(),
        "major":        _selectedMajor,
        "year_level":   yearLevel,
        "photo_url":    null,
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
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = _Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          children: [

            // ── Header يمتد بالكامل دائماً ──────────────────────
            _buildHeader(r, context),

            // ── باقي المحتوى محدود العرض على التابلت ────────────
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: r.contentWidth),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.horizontalPadding,
                        vertical: r.dp(16),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFaceCard(r),
                            SizedBox(height: r.dp(16)),
                            _buildPersonalInfoCard(r),
                            SizedBox(height: r.dp(16)),
                            _buildAcademicInfoCard(r),
                            SizedBox(height: r.dp(24)),
                            _buildSubmitButton(r),
                            SizedBox(height: r.dp(24)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────
  Widget _buildHeader(_Responsive r, BuildContext context) {
    return Container(
      height: r.headerHeight,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: r.dp(20)),
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
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(r.dp(8)),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: r.dp(22),
                    ),
                  ),
                ),
                SizedBox(width: r.dp(16)),
                Flexible(
                  child: Text(
                    "Add New Student",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: r.fs(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: r.dp(12)),
          CircleAvatar(
            radius: r.dp(20),
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person_add,
              color: Colors.blue,
              size: r.dp(22),
            ),
          ),
        ],
      ),
    );
  }

  // ── Face Card ─────────────────────────────────────────────────────
  Widget _buildFaceCard(_Responsive r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.cardRadius),
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
          Row(
            children: [
              Text(
                'Face Embedding',
                style: TextStyle(
                  fontSize: r.fs(19),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
              Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: r.fs(20)),
              ),
            ],
          ),
          SizedBox(height: r.dp(16)),
          Center(
            child: Container(
              width: r.faceCircleSize,
              height: r.faceCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _faceScanned ? const Color(0xFFE8F5E9) : Colors.grey[200],
                border: Border.all(
                  color: _faceScanned ? Colors.green : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: _faceScanned
                    ? Icon(Icons.check_circle, color: Colors.green, size: r.faceIconSize)
                    : SizedBox(
                        width: r.dp(48),
                        height: r.dp(48),
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
                width: r.scanButtonWidth,
                height: r.scanButtonHeight,
                margin: EdgeInsets.only(top: r.dp(16)),
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
                    Icon(Icons.camera_alt, color: Colors.white, size: r.dp(22)),
                    SizedBox(width: r.dp(10)),
                    Text(
                      _faceScanned ? "Rescan Face" : "Scan Face",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: r.fs(17),
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

  // ── Personal Info Card ────────────────────────────────────────────
  Widget _buildPersonalInfoCard(_Responsive r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.cardRadius),
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
          Text(
            'Personal Information',
            style: TextStyle(fontSize: r.fs(20), color: const Color(0xFF1E293B)),
          ),
          SizedBox(height: r.dp(20)),
          _buildLabel('Student Number', r, required: true),
          SizedBox(height: r.dp(8)),
          _buildTextField(
            r: r,
            controller: _studentNumberController,
            hint: 'e.g., 202301001',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            validator: _validateStudentNumber,
          ),
          SizedBox(height: r.dp(16)),
          _buildLabel('Full Name (Arabic)', r, required: true),
          SizedBox(height: r.dp(8)),
          _buildTextField(
            r: r,
            controller: _fullNameArabicController,
            hint: 'Enter full name in Arabic',
            textDirection: TextDirection.rtl,
            validator: _validateRequired,
          ),
          SizedBox(height: r.dp(16)),
          _buildLabel('Full Name (English)', r, required: true),
          SizedBox(height: r.dp(8)),
          _buildTextField(
            r: r,
            controller: _fullNameEnglishController,
            hint: 'Enter full name in English',
            validator: _validateRequired,
          ),
          SizedBox(height: r.dp(16)),
          _buildLabel('Phone Number', r, required: true),
          SizedBox(height: r.dp(8)),
          _buildTextField(
            r: r,
            controller: _phoneController,
            hint: 'e.g., 059XXXXXXX',
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: _validatePhone,
          ),
          SizedBox(height: r.dp(16)),
          _buildLabel('Email Address', r),
          SizedBox(height: r.dp(8)),
          _buildTextField(
            r: r,
            controller: _emailController,
            hint: 'student@university.edu',
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
        ],
      ),
    );
  }

  // ── Academic Info Card ────────────────────────────────────────────
  Widget _buildAcademicInfoCard(_Responsive r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.cardRadius),
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
          Text(
            'Academic Information',
            style: TextStyle(
              fontSize: r.fs(20),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: r.dp(20)),
          _buildLabel('College', r, required: true),
          SizedBox(height: r.dp(8)),
          _buildDropdown(
            r: r,
            value: _selectedCollege,
            hint: 'Select College',
            items: _majorsByCollege.keys.toList(),
            validator: (value) =>
                value == null || value.isEmpty ? 'Please select a college' : null,
            onChanged: (val) {
              setState(() {
                _selectedCollege = val;
                _selectedMajor   = null;
              });
            },
          ),
          SizedBox(height: r.dp(16)),
          _buildLabel('Major', r, required: true),
          SizedBox(height: r.dp(8)),
          _buildDropdown(
            r: r,
            value: _selectedMajor,
            hint: 'Select Major',
            items: _selectedCollege == null ? [] : _majorsByCollege[_selectedCollege]!,
            validator: (value) =>
                value == null || value.isEmpty ? 'Please select a major' : null,
            onChanged: (val) => setState(() => _selectedMajor = val),
          ),
          SizedBox(height: r.dp(16)),
          _buildLabel('Academic Year', r, required: true),
          SizedBox(height: r.dp(8)),
          _buildDropdown(
            r: r,
            value: _selectedYear,
            hint: 'Select academic year',
            items: _years,
            validator: (value) => value == null || value.isEmpty
                ? 'Please select academic year'
                : null,
            onChanged: (val) => setState(() => _selectedYear = val),
          ),
          SizedBox(height: r.dp(8)),
        ],
      ),
    );
  }

  // ── Submit Button ─────────────────────────────────────────────────
  Widget _buildSubmitButton(_Responsive r) {
    return SizedBox(
      width: double.infinity,
      height: r.submitButtonHeight,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A73E8),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade400,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.dp(14)),
          ),
          elevation: 2,
          shadowColor: const Color(0xFF1A73E8).withOpacity(0.4),
        ),
        child: _isSubmitting
            ? SizedBox(
                width: r.dp(26),
                height: r.dp(26),
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add_alt_1, size: r.dp(28)),
                  SizedBox(width: r.dp(8)),
                  Text(
                    'Add Student',
                    style: TextStyle(
                      fontSize: r.fs(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ── Label ─────────────────────────────────────────────────────────
  Widget _buildLabel(String text, _Responsive r, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: r.fs(15),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF475569),
          ),
        ),
        if (required)
          Text(
            ' *',
            style: TextStyle(color: Colors.red, fontSize: r.fs(18)),
          ),
      ],
    );
  }

  // ── Text Field ────────────────────────────────────────────────────
  Widget _buildTextField({
    required _Responsive r,
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
      style: TextStyle(fontSize: r.fs(16), color: const Color(0xFF1E293B)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: const Color(0xFFB0BEC5), fontSize: r.fs(15)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: r.dp(14),
          vertical: r.fieldVerticalPadding,
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

  // ── Dropdown ──────────────────────────────────────────────────────
  Widget _buildDropdown({
    required _Responsive r,
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
        hintStyle: TextStyle(color: const Color(0xFFB0BEC5), fontSize: r.fs(15)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: r.dp(14),
          vertical: r.fieldVerticalPadding,
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
      style: TextStyle(fontSize: r.fs(15), color: const Color(0xFF1E293B)),
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8)),
      items: items
          .map((item) => DropdownMenuItem<String>(value: item, child: Text(item)))
          .toList(),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// CORNER BRACKET PAINTER
// ══════════════════════════════════════════════════════════════════════
class _CornerBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = const Color(0xFF94A3B8)
      ..strokeWidth = 3
      ..style       = PaintingStyle.stroke
      ..strokeCap   = StrokeCap.round;

    const len = 12.0;

    canvas.drawLine(Offset(0, len), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(len, 0), paint);
    canvas.drawLine(Offset(size.width - len, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), paint);
    canvas.drawLine(Offset(0, size.height - len), Offset(0, size.height), paint);
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
