import 'package:flutter/material.dart';
import 'package:faceapp/screens/verifier_screen.dart';
import 'package:faceapp/screens/admin_screen.dart';
import 'package:faceapp/screens/registrar_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<String?> login() async {
    await Future.delayed(Duration(seconds: 1));
    // للتجربة TEST !!!
    if (_usernameController.text == "admin" &&
        _passwordController.text == "456987") {
      return "admin";
    } else if (_usernameController.text == "verifier" &&
        _passwordController.text == "741852") {
      return "verifier";
    } else if (_usernameController.text == "registrar" &&
        _passwordController.text == "963147") {
      return "registrar";
    } else {
      return null;
    }
    //API الحقيقي هنا
  }

  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 280,
                width: 300,
                child: Image.asset("assets/Images/logo.jpeg"),
              ),
              SizedBox(height: 20),
              Text(
                "System Authentication",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 36, 53, 73),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Authorized users only",
                style: TextStyle(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 133, 132, 132),
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 370,

                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          label: Text(
                            "User name",
                            style: TextStyle(fontSize: 17),
                          ),
                          hintText: "Enter your name",
                          hintStyle: TextStyle(fontSize: 18),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.cyan,
                              width: 3,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.cyan,
                              width: 3,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "User name is required";
                          }
                          if (v.contains('@')) {
                            return "No @ allowed";
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(height: 30),
                    SizedBox(
                      width: 370,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text(
                            "Password",
                            style: TextStyle(fontSize: 17),
                          ),
                          hintText: "Enter your Password",
                          hintStyle: TextStyle(fontSize: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.cyan,
                              width: 3,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.cyan,
                              width: 3,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Password is required";
                          }
                          if (v.length < 6) {
                            return "At least 6 characters";
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forget Password?",
                          style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 45),
                    Container(
                      width: 280,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String? role = await login();
                            if (role == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Invalid credentials")),
                              );
                              return;
                            }
                            if (role == "admin") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AdminScreen(),
                                ),
                              );
                            } else if (role == "verifier") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Verifierscreen(),
                                ),
                              );
                            } else if (role == "registrar") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegistrarScreen(),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
