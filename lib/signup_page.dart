import 'package:flutter/material.dart';
import 'login_page.dart';
import 'TermsAndConditionsPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _gradYearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004990),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "SuRate",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInput(
                      "Email",
                      _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Email cannot be empty";
                        if (!value.contains("@")) return "Enter a valid email";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInput(
                      "Username",
                      _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Username cannot be empty";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInput(
                      "Password",
                      _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6)
                          return "Password must be at least 6 characters";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInput(
                      "Confirm Password",
                      _confirmPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text)
                          return "Passwords do not match";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInput(
                      "Graduation Year",
                      _gradYearController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Graduation year cannot be empty";
                        final year = int.tryParse(value);
                        if (year == null || year < 2024 || year > 2035)
                          return "Enter a valid graduation year";
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsAndConditionsPage(),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Invalid Input"),
                        content: const Text("Please correct the errors."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  width: 200,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFADD8FF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF004990),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: const Text(
                  "Already have an account? Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Image.asset(
                "assets/images/github_icon.png",
                width: 40,
                height: 40,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
        ),
      ),
    );
  }
}
