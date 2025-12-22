import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  User? _user;

  ThemeMode get themeMode => _themeMode;

  void updateUser(User? user) {
    if (_user == user) return;
    _user = user;
    _loadTheme();
  }

  String get _themePrefKey {
    return "isDark_${_user?.uid ?? 'default'}";
  }

  void _loadTheme() async {
    if (_user == null) {
      _themeMode = ThemeMode.light;
      notifyListeners();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themePrefKey) ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    if (_user == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePrefKey, isDark);
  }
}
