import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_paddings.dart';
import '../../core/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SuRate Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.globalSearch);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 48,
                    width: 48,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'SuRate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Select Faculty & Course'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.selectFaculty);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Lectures'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.lecturesList);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Comments'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.comments);
              },
            ),
            ListTile(
              leading: const Icon(Icons.forum),
              title: const Text('Discussions'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.discussions);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: AppPaddings.screen,
        child: isPortrait
            ? const _HomeContent()
            : Row(
                children: const [
                  Expanded(child: _HomeContent()),
                  SizedBox(width: 16),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Welcome to SuRate.\nSelect an option from the drawer.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Page\nBrowse faculties, departments, and courses.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

