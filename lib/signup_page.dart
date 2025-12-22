import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import 'login_page.dart';
import 'TermsAndConditionsPage.dart';
import 'package:surate/providers/auth_provider.dart';

import 'wrappers/auth_wrapper.dart';

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
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _gradYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004990),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
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
                    _input(
                      "Email",
                      _emailController,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Email boş olamaz";
                        if (!v.contains("@")) return "Geçerli bir email giriniz";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _input(
                      "Username",
                      _usernameController,
                      validator: (v) =>
                      v == null || v.isEmpty ? "Kullanıcı adı boş olamaz" : null,
                    ),
                    const SizedBox(height: 16),
                    _input(
                      "Password",
                      _passwordController,
                      obscure: true,
                      validator: (v) =>
                      v == null || v.length < 6
                          ? "En az 6 karakter olmalı"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _input(
                      "Confirm Password",
                      _confirmPasswordController,
                      obscure: true,
                      validator: (v) =>
                      v != _passwordController.text
                          ? "Şifreler eşleşmiyor"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _input(
                      "Graduation Year",
                      _gradYearController,
                      keyboard: TextInputType.number,
                      validator: (v) {
                        final year = int.tryParse(v ?? "");
                        if (year == null || year < 2024 || year > 2035) {
                          return "Geçerli bir mezuniyet yılı giriniz";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final auth = Provider.of<AuthProvider>(context, listen: false);

                  try {
                    await auth.register(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                      _usernameController.text.trim(),
                    );
                    
                    if (!mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TermsAndConditionsPage(),
                      ),
                    );

                  } catch (e) {
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Kayıt Başarısız"),
                        content: Text(e.toString()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("TAMAM"),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: _button("Sign Up"),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthWrapper()),
                        (route) => false,
                  );
                },
                child: const Text(
                  "Already have an account? Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
      String label,
      TextEditingController controller, {
        bool obscure = false,
        TextInputType? keyboard,
        required String? Function(String?) validator,
      }) {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _button(String text) {
    return Container(
      width: 200,
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFADD8FF),
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Color(0xFF004990),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
