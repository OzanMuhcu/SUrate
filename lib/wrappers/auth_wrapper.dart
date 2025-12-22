import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login_page.dart';
import '../signup_page.dart';
import '../MainPage.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLogin = true;

  void toggle() => setState(() => isLogin = !isLogin);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // If logged in, always show HomePage. 
          // Resetting isLogin here ensures that if they log out later, they start at LoginPage.
          return const HomePage();
        } else {
          return isLogin
              ? LoginPage(onClickedSignUp: toggle)
              : SignUpPage(onClickedSignIn: toggle);
        }
      },
    );
  }
}
