import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:surate/providers/theme_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            final user = snapshot.data;

            return Column(
              children: [
                const Text(
                  "SuRate",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004990),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 45,
                          backgroundColor: Color(0xFFE0D9FF),
                          child:
                              Icon(Icons.person, size: 45, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user?.displayName ?? "İsim yok",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? "Email yok",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Class of 2028",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 20),
                        _buildThemeSwitch(context),
                        const SizedBox(height: 10),
                        _buildButton("Change Username", () {}),
                        _buildButton("Change Password", () {}),
                        _buildButton("Delete Account", () {}),
                        _buildButton("Logout", () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          }
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  "assets/images/github_icon.png",
                  width: 40,
                  height: 40,
                  errorBuilder: (ctx, err, stack) =>
                      const Icon(Icons.code, size: 40),
                ),
                const SizedBox(height: 30),
              ],
            );
          }),
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Dark Mode"),
          Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 220,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFADD8FF),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
