import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:surate/providers/auth_provider.dart' as app_auth;
import 'package:surate/signup_page.dart';

class _FakeAuthProvider extends ChangeNotifier implements app_auth.AuthProvider {
  bool registerCalled = false;
  String? lastEmail;
  String? lastPassword;
  String? lastName;

  @override
  firebase_auth.User? get user => null;

  @override
  bool get isLoggedIn => false;

  @override
  bool get isAuthChecking => false;

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> register(String email, String password, String name) async {
    registerCalled = true;
    lastEmail = email;
    lastPassword = password;
    lastName = name;
  }
}

void main() {
  testWidgets(
    'SignUpPage validates inputs and calls register with valid data',
    (tester) async {
      final fakeAuth = _FakeAuthProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<app_auth.AuthProvider>.value(
          value: fakeAuth,
          child: const MaterialApp(home: SignUpPage()),
        ),
      );

      final signUpButton = find.widgetWithText(GestureDetector, 'Sign Up');

      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pump();

      expect(find.text('Email boş olamaz'), findsOneWidget);
      expect(find.text('Kullanıcı adı boş olamaz'), findsOneWidget);
      expect(find.text('En az 6 karakter olmalı'), findsOneWidget);
      expect(find.text('Geçerli bir mezuniyet yılı giriniz'), findsOneWidget);
      expect(fakeAuth.registerCalled, isFalse);

      await tester.enterText(find.byType(TextFormField).at(0), 'student@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'student');
      await tester.enterText(find.byType(TextFormField).at(2), '123456');
      await tester.enterText(find.byType(TextFormField).at(3), '123456');
      await tester.enterText(find.byType(TextFormField).at(4), '2025');

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(fakeAuth.registerCalled, isTrue);
      expect(fakeAuth.lastEmail, 'student@example.com');
      expect(fakeAuth.lastPassword, '123456');
      expect(fakeAuth.lastName, 'student');
      expect(find.text('Terms & Conditions'), findsOneWidget);
    },
  );
}
