import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:surate/login_page.dart';
import 'package:surate/providers/auth_provider.dart' as app_auth;

class _FakeAuthProvider extends ChangeNotifier implements app_auth.AuthProvider {
  bool loginCalled = false;

  @override
  firebase_auth.User? get user => null;

  @override
  bool get isLoggedIn => false;

  @override
  bool get isAuthChecking => false;

  @override
  Future<void> login(String email, String password) async {
    loginCalled = true;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> register(String email, String password, String name) async {}
}

void main() {
  testWidgets(
    'LoginPage shows validation errors for empty and invalid input',
    (tester) async {
      final fakeAuth = _FakeAuthProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<app_auth.AuthProvider>.value(
          value: fakeAuth,
          child: const MaterialApp(home: LoginPage()),
        ),
      );

      final loginButton = find.widgetWithText(GestureDetector, 'Login');

      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Please enter email'), findsOneWidget);
      expect(find.text('Please enter password'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');
      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(fakeAuth.loginCalled, isFalse);
    },
  );
}
