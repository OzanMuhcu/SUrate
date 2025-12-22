import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surate/providers/auth_provider.dart';

import '../login_page.dart';
import '../MainPage.dart';// Dosya ismin MainPage.dart ise

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider'ı dinle (watch)
    final authProvider = context.watch<AuthProvider>();

    // Eğer kullanıcı giriş yapmışsa HomePage, yapmamışsa LoginPage göster
    if (authProvider.isLoggedIn) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}