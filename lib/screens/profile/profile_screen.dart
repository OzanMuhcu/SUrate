import 'package:flutter/material.dart';

import '../../core/app_paddings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: AppPaddings.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/583231?v=4',
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'demo_user',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Taken Courses:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('- CS310 Database Systems'),
            const Text('- CS201 Algorithms'),
            const SizedBox(height: 16),
            const Text(
              'Actions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('- Change Password'),
            const Text('- Update Username'),
          ],
        ),
      ),
    );
  }
}

