import 'package:flutter/material.dart';

import '../../core/app_paddings.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _difficulty = 3;
  double _examChallenge = 3;
  double _projectWorkload = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Course'),
      ),
      body: Padding(
        padding: AppPaddings.screen,
        child: ListView(
          children: [
            _buildSlider(
              title: 'Difficulty',
              value: _difficulty,
              onChanged: (value) {
                setState(() {
                  _difficulty = value;
                });
              },
            ),
            _buildSlider(
              title: 'Exam Challenge',
              value: _examChallenge,
              onChanged: (value) {
                setState(() {
                  _examChallenge = value;
                });
              },
            ),
            _buildSlider(
              title: 'Project Workload',
              value: _projectWorkload,
              onChanged: (value) {
                setState(() {
                  _projectWorkload = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Comments (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

