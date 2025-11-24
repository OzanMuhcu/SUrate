import 'package:flutter/material.dart';

import '../../core/app_paddings.dart';
import '../../core/app_routes.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: Padding(
        padding: AppPaddings.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Terms & Conditions placeholder text.\n\n'
                  'This screen is an essential step in the user registration '
                  'process. Users should read and accept these terms before '
                  'creating an account.',
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _accepted,
                  onChanged: (value) {
                    setState(() {
                      _accepted = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text('I have read and I accept.'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Go Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _accepted
                        ? () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.home,
                            );
                          }
                        : null,
                    child: const Text('Move On'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
