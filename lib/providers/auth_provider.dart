import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      _user = user;
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
