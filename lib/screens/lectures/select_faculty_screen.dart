import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_paddings.dart';
import '../../core/app_routes.dart';

class SelectFacultyScreen extends StatelessWidget {
  const SelectFacultyScreen({super.key});

  void _openLectures(BuildContext context, String facultyName) {
    Navigator.pushNamed(
      context,
      AppRoutes.lecturesList,
      arguments: facultyName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 700;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FacultyCard(
          label: 'Faculty of Engineering and Natural Sciences',
          onTap: () => _openLectures(
            context,
            'Faculty of Engineering and Natural Sciences',
          ),
        ),
        const SizedBox(height: 16),
        _FacultyCard(
          label: 'Faculty of Arts and Social Sciences',
          onTap: () => _openLectures(
            context,
            'Faculty of Arts and Social Sciences',
          ),
        ),
        const SizedBox(height: 16),
        _FacultyCard(
          label: 'Sabancı Business School',
          onTap: () => _openLectures(
            context,
            'Sabancı Business School',
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.bottomLeft,
          child: IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'View on GitHub',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('GitHub link will be added later.'),
                ),
              );
            },
          ),
        ),
      ],
    );

    if (isWide) {
      content = Row(
        children: [
          Expanded(child: content),
          const VerticalDivider(width: 32),
          const Expanded(
            child: SizedBox.shrink(),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Select Faculty and Course'),
      ),
      body: Padding(
        padding: AppPaddings.screen,
        child: content,
      ),
    );
  }
}

class _FacultyCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FacultyCard({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: AppPaddings.horizontal,
          height: 72,
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

