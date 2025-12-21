import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:surate/providers/auth_provider.dart';
import 'package:surate/login_page.dart';
import 'package:surate/MainPage.dart'; // dosya adı aynı kalıyor

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoggedIn) {
      return HomePage();   
    } else {
      return LoginPage();
    }
  }
}
