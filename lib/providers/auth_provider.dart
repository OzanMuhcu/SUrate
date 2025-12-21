import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    // 🔥 Firebase auth session listener
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // 🔐 LOGIN
  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
  }

  // 📝 REGISTER
  Future<void> signUp(String email, String password) async {
    await _authService.signUp(email, password);
  }

  // 🚪 LOGOUT
  Future<void> signOut() async {
    await _authService.signOut();
  }
}
