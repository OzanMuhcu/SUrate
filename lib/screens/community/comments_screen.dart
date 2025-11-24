import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_paddings.dart';
import '../../core/app_routes.dart';
import '../../models/comment.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late List<Comment> _comments;
  late List<int> _likes;
  late List<int> _dislikes;

  @override
  void initState() {
    super.initState();
    _comments = [
      Comment(
        id: '1',
        lectureId: '1',
        author: 'Student A',
        text: 'Great course, but demanding.',
        rating: 4.5,
        createdAt: DateTime.now(),
      ),
      Comment(
        id: '2',
        lectureId: '1',
        author: 'Student B',
        text: 'Exams are challenging but fair.',
        rating: 4.0,
        createdAt: DateTime.now(),
      ),
    ];

    _likes = List<int>.filled(_comments.length, 0);
    _dislikes = List<int>.filled(_comments.length, 0);
  }

  double get _averageRating {
    if (_comments.isEmpty) {
      return 0;
    }
    final total = _comments.fold<double>(
      0,
      (sum, c) => sum + c.rating,
    );
    return total / _comments.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.forum),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.discussions);
            },
          ),
        ],
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
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'Course Difficulty: ${_averageRating.toStringAsFixed(1)} / 5.0',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return Card(
                    margin: AppPaddings.itemSpacing,
                    child: Padding(
                      padding: AppPaddings.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.author,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(comment.text),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up),
                                onPressed: () {
                                  setState(() {
                                    _likes[index]++;
                                  });
                                },
                              ),
                              Text(_likes[index].toString()),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.thumb_down),
                                onPressed: () {
                                  setState(() {
                                    _dislikes[index]++;
                                  });
                                },
                              ),
                              Text(_dislikes[index].toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add comment screen will be implemented later.'),
            ),
          );
        },
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}
