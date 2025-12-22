import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surate/providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onClickedSignIn;
  const SignUpPage({super.key, required this.onClickedSignIn});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_loading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await context.read<AuthProvider>().register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // AuthWrapper authStateChanges ile Home'a geçecek
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004990),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
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
                        if (v == null || v.isEmpty) {
                          return "Email boş olamaz";
                        }
                        if (!v.contains("@")) {
                          return "Geçerli email gir";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _input(
                      "Password",
                      _passwordController,
                      obscure: true,
                      validator: (v) {
                        if (v == null || v.length < 6) {
                          return "En az 6 karakter";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _input(
                      "Confirm Password",
                      _confirmPasswordController,
                      obscure: true,
                      validator: (v) {
                        if (v != _passwordController.text) {
                          return "Şifreler eşleşmiyor";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: _loading ? null : _signUp,
                child: _button(_loading ? "Loading..." : "Sign Up"),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: widget.onClickedSignIn,
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
        required String? Function(String?) validator,
      }) {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
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
