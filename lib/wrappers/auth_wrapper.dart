import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Make sure these paths match your file structure
import '../login_page.dart';
import '../MainPage.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // Check if the stream is still waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is logged in (snapshot has data), go to HomePage
        if (snapshot.hasData) {
          // The class name inside MainPage.dart is HomePage
          return const HomePage();
        }

        // If user is not logged in, go to LoginPage
        return const LoginPage();
      },
    );
  }
}