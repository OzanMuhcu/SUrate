import 'package:flutter/material.dart';
import 'RatePage.dart';

class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> courseData;

  const CourseDetailPage({super.key, required this.courseData});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final List<Map<String, String>> _comments = [
    {
      'author': 'Ozan M.',
      'date': 'Oct 24, 2024',
      'comment':
          'The course was really challenging but rewarding. Projects teach a lot.',
    },
    {
      'author': 'Yiğit N.',
      'date': 'Nov 02, 2024',
      'comment': 'Great explanations but be ready for the exams.',
    },
    {
      'author': 'Berkay B.',
      'date': 'Sep 15, 2024',
      'comment': 'Practical assignments were the best part.',
    },
    {
      'author': 'Student 2023',
      'date': 'Aug 10, 2024',
      'comment': 'Lectures could be more organized but okay overall.',
    },
  ];

  late final List<int> _likes;
  late final List<int> _dislikes;

  @override
  void initState() {
    super.initState();

    _likes = List<int>.filled(_comments.length, 0);
    _dislikes = List<int>.filled(_comments.length, 0);
  }

  void _incrementLike(int index) {
    setState(() {
      _likes[index]++;
    });
  }

  void _incrementDislike(int index) {
    setState(() {
      _dislikes[index]++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String courseCode = widget.courseData['code'] ?? "CS 101";
    final double rating = (widget.courseData['rating'] is num)
        ? widget.courseData['rating'].toDouble()
        : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF004990),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          courseCode,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RateCoursePage()),
          );

          if (result != null && result is Map<String, String>) {
            setState(() {
              _comments.insert(0, result);

              _likes.insert(0, 0);
              _dislikes.insert(0, 0);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Thanks for your review!")),
            );
          }
        },
        backgroundColor: const Color(0xFF004990),
        child: const Icon(Icons.star, color: Colors.white, size: 28),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.grey[300],
            child: Column(
              children: [
                const Text(
                  "Course Difficulty",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    if (index < rating.floor()) {
                      return const Icon(
                        Icons.star,
                        size: 35,
                        color: Colors.amber,
                      );
                    } else if (index < rating && (rating - index) >= 0.5) {
                      return const Icon(
                        Icons.star_half,
                        size: 35,
                        color: Colors.amber,
                      );
                    } else {
                      return const Icon(
                        Icons.star_border,
                        size: 35,
                        color: Colors.amber,
                      );
                    }
                  }),
                ),
                const SizedBox(height: 5),
                Text(
                  "$rating / 5.0",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _comments.length,
              separatorBuilder: (context, index) => const Divider(height: 30),
              itemBuilder: (context, index) {
                final c = _comments[index];
                return _CommentCard(
                  author: c['author'] ?? '',
                  date: c['date'] ?? '',
                  comment: c['comment'] ?? '',
                  likeCount: _likes[index],
                  dislikeCount: _dislikes[index],
                  onLike: () => _incrementLike(index),
                  onDislike: () => _incrementDislike(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final String author;
  final String date;
  final String comment;
  final int likeCount;
  final int dislikeCount;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const _CommentCard({
    required this.author,
    required this.date,
    required this.comment,
    required this.likeCount,
    required this.dislikeCount,
    required this.onLike,
    required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[300],
          child: Text(
            author.isNotEmpty ? author[0] : '?',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF004990),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    author,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                comment,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: onLike,
                    borderRadius: BorderRadius.circular(5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.thumb_up_alt_outlined,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$likeCount",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: onDislike,
                    borderRadius: BorderRadius.circular(5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.thumb_down_alt_outlined,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$dislikeCount",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
