import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF004990),
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
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
                    child: Icon(Icons.person, size: 45, color: Colors.black87),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Yağmur Geçim",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),
                  const Text(
                    "yagmur@sabanci.com",
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 4),
                  const Text(
                    "Class of 2028",
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 30),

                  _buildButton("Change Username"),
                  _buildButton("Change Password"),
                  _buildButton("Delete Account"),
                  _buildButton("Logout"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Image.asset(
            "assets/images/github_icon.png",
            width: 40,
            height: 40,
            errorBuilder: (ctx, err, stack) => const Icon(Icons.code, size: 40),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
    );
  }
}
