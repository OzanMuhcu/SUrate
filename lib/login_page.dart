import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginPage({super.key, required this.onClickedSignUp});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_loading) return;
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    debugPrint('LOGIN EMAIL => $email');

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // AuthWrapper otomatik HomePage’e yönlendirir
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? e.code)),
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
                'SuRate',
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
                      label: 'Email',
                      controller: _emailController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Email boş olamaz';
                        }
                        if (!v.contains('@')) {
                          return 'Geçerli email gir';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _input(
                      label: 'Password',
                      controller: _passwordController,
                      obscure: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Şifre boş olamaz';
                        }
                        if (v.length < 6) {
                          return 'En az 6 karakter';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// ✅ TEK, NET, SORUNSUZ BUTON
              _button(
                text: _loading ? 'Loading...' : 'Sign In',
                onTap: _loading ? null : _login,
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: widget.onClickedSignUp,
                child: const Text(
                  "Don't have an account? Sign Up",
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

  Widget _input({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    required String? Function(String?) validator,
  }) {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        autocorrect: false,
        enableSuggestions: false,
        autofillHints: const [],
        textCapitalization: TextCapitalization.none,
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

  Widget _button({
    required String text,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
      ),
    );
  }
}
