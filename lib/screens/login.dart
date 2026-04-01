import 'dart:convert';

import 'package:faceapp/config/user_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:faceapp/config/api_config.dart';
import 'package:faceapp/screens/admin_screen.dart';
import 'package:faceapp/screens/registrar_screen.dart';
import 'package:faceapp/screens/verifier_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<Map<String, dynamic>?> login() async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/auth/login");

    try {
      final response = await http
          .post(
            uri,
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "username": _usernameController.text.trim(),
              "password": _passwordController.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        }
      }

      if (response.statusCode == 401) {
        throw Exception("Invalid username or password");
      }

      throw Exception("Server error: ${response.statusCode}");
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  void _showMessage(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _goToRoleScreen(String role) {
    final normalizedRole = role.trim().toLowerCase();

    if (normalizedRole == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminScreen()),
      );
    } else if (normalizedRole == "verifier") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
         builder: (_) => Verifierscreen(userData: currentUser),
          ),
      );
    } else if (normalizedRole == "registrar") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegistrarScreen()),
      );
    } else {
      _showMessage("Unknown user role: $role", backgroundColor: Colors.red);
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await login();

      if (result == null) {
        _showMessage("Login failed", backgroundColor: Colors.red);
        return;
      }

      final role = result["role"]?.toString();

      if (role == null || role.isEmpty) {
        _showMessage("Role not found in response", backgroundColor: Colors.red);
        return;
      }

      _showMessage("Login successful", backgroundColor: Colors.green);
      _goToRoleScreen(role);
    } catch (e) {
      _showMessage(e.toString(), backgroundColor: Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
@override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isMobile = screenWidth < 700;
    final bool isDesktop = screenWidth >= 1000;
    final bool isTablet = !isMobile && !isDesktop;

    final double titleFontSize = isMobile ? 24 : (isTablet ? 28 : 36);
    final double subTitleFontSize = isMobile ? 16 : (isTablet ? 18 : 20);
    final double fieldFontSize = isMobile ? 16 : (isTablet ? 17 : 18);
    final double buttonFontSize = isMobile ? 19 : (isTablet ? 20 : 22);
    final double logoWidth = isMobile
        ? screenWidth * 0.52
        : (isTablet ? 260 : 360);

    return Scaffold(
      backgroundColor:Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 28,
              vertical: isMobile ? 20 : 28,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 1180 : 620,
              ),
              child: isDesktop
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 42,
                        vertical: 40,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 11,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 34),
                              child: _buildHeader(
                                logoWidth: logoWidth,
                                titleFontSize: titleFontSize,
                                subTitleFontSize: subTitleFontSize,
                                centerContent: false,
                              ),
                            ),
                          ),
                          Container(
                            width: 1.2,
                            height: 440,
                            color: Colors.black12,
                          ),
                          const SizedBox(width: 42),
                          Expanded(
                            flex: 10,
                            child: _buildForm(
                              fieldFontSize: fieldFontSize,
                              buttonFontSize: buttonFontSize,
                              isDesktop: true,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 20 : 28,
                        vertical: isMobile ? 24 : 34,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(
                            logoWidth: logoWidth,
                            titleFontSize: titleFontSize,
                            subTitleFontSize: subTitleFontSize,
                            centerContent: true,
                          ),
                          SizedBox(height: isTablet ? 36 : 28),
                          _buildForm(
                            fieldFontSize: fieldFontSize,
                            buttonFontSize: buttonFontSize,
                            isDesktop: false,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildHeader({
    required double logoWidth,
    required double titleFontSize,
    required double subTitleFontSize,
    required bool centerContent,
  }) {
    return Column(
      crossAxisAlignment:
          centerContent ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: logoWidth,
          child: Image.asset(
            "assets/Images/logo.jpeg",
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "System Authentication",
          textAlign: centerContent ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF243549),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Authorized users only",
          textAlign: centerContent ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: subTitleFontSize,
            color: const Color(0xFF858484),
          ),
        ),
      ],
    );
  }

  Widget _buildForm({
    required double fieldFontSize,
    required double buttonFontSize,
    required bool isDesktop,
  }) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            style: TextStyle(fontSize: fieldFontSize),
            decoration: InputDecoration(
              labelText: "Username",
              hintText: "Enter your username",
              prefixIcon: const Icon(Icons.person_outline),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: isDesktop ? 22 : 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Colors.cyan,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Colors.cyan,
                  width: 2.5,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return "Username is required";
              }
              if (v.contains('@')) {
                return "No @ allowed";
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            style: TextStyle(fontSize: fieldFontSize),
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: isDesktop ? 22 : 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Colors.cyan,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Colors.cyan,
                  width: 2.5,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return "Password is required";
              }
              if (v.trim().length < 6) {
                return "At least 6 characters";
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                _showMessage("Forgot password is not implemented yet");
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop ? 17 : 16,
                ),
              ),
            ),
          ),
          SizedBox(height: isDesktop ? 26 : 18),
          SizedBox(
            width: double.infinity,
            height: isDesktop ? 62 : 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
}