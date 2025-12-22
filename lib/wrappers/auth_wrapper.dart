import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surate/providers/auth_provider.dart';

import '../login_page.dart';
import '../MainPage.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isLoggedIn) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}