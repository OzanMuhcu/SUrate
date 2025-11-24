import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_paddings.dart';
import '../../core/app_routes.dart';
import '../../models/discussion.dart';

class DiscussionsScreen extends StatelessWidget {
  const DiscussionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final discussions = <Discussion>[
      Discussion(
        id: '1',
        title: 'Best electives for CS students?',
        author: 'Yiğit N.',
        preview: 'What electives would you recommend for...',
        createdAt: DateTime.now(),
      ),
      Discussion(
        id: '2',
        title: 'How hard is CS310?',
        author: 'Berkay B.',
        preview: 'I heard CS310 has a heavy project...',
        createdAt: DateTime.now(),
      ),
      Discussion(
        id: '3',
        title: 'Exchange programs at Sabancı',
        author: 'Ozan M.',
        preview: 'Anyone with experience in exchange programs?',
        createdAt: DateTime.now(),
      ),
    ];

    final colors = [
      Colors.orange.shade100,
      Colors.lightBlue.shade100,
      Colors.lightGreen.shade100,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussions'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Comments'),
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.comments);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: AppPaddings.screen,
        child: ListView.builder(
          itemCount: discussions.length,
          itemBuilder: (context, index) {
            final discussion = discussions[index];
            return Card(
              color: colors[index % colors.length],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: AppPaddings.itemSpacing,
              child: ListTile(
                title: Text(discussion.title),
                subtitle: Text('${discussion.author} • ${discussion.preview}'),
                onTap: () {
                  // Future: navigate to discussion details.
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New discussion flow will be implemented later.'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

