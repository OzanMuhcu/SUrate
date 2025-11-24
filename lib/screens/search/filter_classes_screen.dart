import 'package:flutter/material.dart';

import '../../core/app_paddings.dart';

class FilterClassesScreen extends StatelessWidget {
  const FilterClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double studyHours = 5;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Filter Classes'),
        actions: [
          TextButton(
            onPressed: () {
              // Reset filters can be implemented later.
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: AppPaddings.screen,
            child: ListView(
              children: [
                const Text('Subject'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  items: const [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text('All'),
                    ),
                  ],
                  onChanged: (_) {},
                ),
                const SizedBox(height: 16),
                const Text('Teacher'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  items: const [
                    DropdownMenuItem(
                      value: 'any',
                      child: Text('Any'),
                    ),
                  ],
                  onChanged: (_) {},
                ),
                const SizedBox(height: 16),
                const Text('Overall Rating'),
                Slider(
                  value: 3,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '3+',
                  onChanged: (_) {},
                ),
                const SizedBox(height: 16),
                const Text('Expected Study Hours (per week)'),
                Slider(
                  value: studyHours,
                  min: 0,
                  max: 20,
                  divisions: 20,
                  label: '${studyHours.round()}h',
                  onChanged: (value) {
                    setState(() {
                      studyHours = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Graded Attendance'),
                  value: true,
                  onChanged: (_) {},
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: AppPaddings.screen,
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Show Classes'),
          ),
        ),
      ),
    );
  }
}

