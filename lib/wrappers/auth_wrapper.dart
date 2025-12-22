import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🔥 DOĞRU IMPORTLAR (bir üst klasör)
import '../login_page.dart';
import '../MainPage.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Firebase auth kontrol ederken
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Login olmuşsa
        if (snapshot.hasData) {
          return HomePage(); // MainPage.dart içindeki class
        }

        // Login değilse
        return LoginPage(); // ❌ const YOK
      },
    );
  }
}
