import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _initialized = false;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      _initialized = true;
      notifyListeners();
    });
  }

  bool get isInitialized => _initialized;
  bool get isLoggedIn => _user != null;
  User? get user => _user;

  Future<void> register(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
