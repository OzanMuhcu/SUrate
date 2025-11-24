import 'package:flutter/material.dart';

import '../../core/app_paddings.dart';
import '../../core/app_routes.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: AppPaddings.screen,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width > 600 ? 480 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Graduation Year',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: AppPaddings.horizontal,
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.terms);
            },
            child: const Text('Continue to Terms & Conditions'),
          ),
        ),
      ),
    );
  }
}
