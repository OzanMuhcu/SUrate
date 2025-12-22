import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isAuthChecking = true;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isAuthChecking => _isAuthChecking;

  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      _user = user;
      _isAuthChecking = false;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    await _authService.signIn(email, password);
  }

  Future<void> register(String email, String password, String name) async {
    final user = await _authService.signUp(email, password);
    await user?.updateDisplayName(name);
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
