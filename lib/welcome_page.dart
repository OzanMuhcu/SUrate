import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004990),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    const Text(
                      "SuRate",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: 220,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text("Sign in"),
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: 220,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text("Sign up"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Image.asset(
                "assets/images/github_icon.png",
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.code, color: Colors.white, size: 40);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
