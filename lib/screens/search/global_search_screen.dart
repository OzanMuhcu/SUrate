import 'package:flutter/material.dart';

import '../../core/app_paddings.dart';
import '../../core/app_routes.dart';
import '../../models/lecture.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Lecture> _allLectures = const [
    Lecture(
      id: '1',
      code: 'CS310',
      title: 'Database Systems',
      instructor: 'Dr. Smith',
      credits: 3,
    ),
    Lecture(
      id: '2',
      code: 'CS201',
      title: 'Algorithms',
      instructor: 'Dr. Doe',
      credits: 3,
    ),
    Lecture(
      id: '3',
      code: 'MATH101',
      title: 'Calculus I',
      instructor: 'Dr. Taylor',
      credits: 4,
    ),
  ];

  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final results = _query.isEmpty
        ? <Lecture>[]
        : _allLectures
            .where(
              (l) =>
                  l.title.toLowerCase().contains(_query.toLowerCase()) ||
                  l.code.toLowerCase().contains(_query.toLowerCase()) ||
                  l.instructor.toLowerCase().contains(_query.toLowerCase()),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppPaddings.screen,
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: size.width > 600 ? 480 : double.infinity,
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Search courses, codes, instructors',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    setState(() {
                      _query = value.trim();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _query.isEmpty
                  ? const Center(
                      child: Text(
                        'Type a keyword and press Enter to search.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : results.isEmpty
                      ? const Center(
                          child: Text(
                            'No matches found.',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final lecture = results[index];
                            return ListTile(
                              title: Text('${lecture.code} - ${lecture.title}'),
                              subtitle: Text(lecture.instructor),
                              onTap: () {
                                // Later: navigate to lecture detail page.
                              },
                            );
                          },
                        ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.selectFaculty);
                },
                child: const Text('Go to Select Faculty'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

