import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;

  // Başlangıçta kontrol yapıldığı için true olarak başlatıyoruz
  bool _isAuthChecking = true;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isAuthChecking => _isAuthChecking; // Dışarıdan erişim için getter

  AuthProvider() {
    // Auth durumunu dinlemeye başla
    _authService.authStateChanges.listen((user) {
      _user = user;
      _isAuthChecking = false; // Firebase'den cevap geldi, yükleme bitti
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    await _authService.signIn(email, password);
  }

  Future<void> register(String email, String password) async {
    await _authService.signUp(email, password);
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}