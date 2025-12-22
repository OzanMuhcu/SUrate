import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surate/models/comment.dart';
import 'package:surate/models/course.dart';
import 'package:surate/providers/auth_provider.dart';
import 'package:surate/providers/data_provider.dart';
import 'RatePage.dart'; // ✅ DÜZELTİLDİ: Senin dosya adın bu.
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> courseData;
  const CourseDetailPage({super.key, required this.courseData});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  @override
  Widget build(BuildContext context) {
    final String courseId = widget.courseData['id'] as String? ?? "";
    final String courseCode = widget.courseData['code'] as String? ?? "Unknown";

    final dataProvider = context.watch<DataProvider>();
    final authProvider = context.watch<AuthProvider>();

    // Canlı veri çekme
    Course? liveCourse;
    try {
      liveCourse = dataProvider.courses.firstWhere((c) => c.id == courseId);
    } catch (e) {
      liveCourse = null;
    }

    final double currentRating = liveCourse?.rating ??
        ((widget.courseData['rating'] is num) ? widget.courseData['rating'].toDouble() : 0.0);

    final int ratingCount = liveCourse?.ratingCount ??
        ((widget.courseData['ratingCount'] is num) ? widget.courseData['ratingCount'].toInt() : 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004990),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(courseCode, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
      ),

      // ✅ RatePage'e gitme butonu (DÜZELTİLDİ)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (authProvider.user == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login required.")));
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RateCoursePage(
                courseId: courseId,     // ✅ ID GÖNDERİLİYOR
                courseCode: courseCode, // ✅ KOD GÖNDERİLİYOR
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF004990),
        child: const Icon(Icons.star, color: Colors.white, size: 28),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 20), color: Colors.grey[300],
            child: Column(
              children: [
                const Text("Course Difficulty", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                RatingBarIndicator(
                  rating: currentRating, itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5, itemSize: 35.0, direction: Axis.horizontal,
                ),
                const SizedBox(height: 5),
                Text("${currentRating.toStringAsFixed(1)} / 5.0  ($ratingCount reviews)", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Expanded(
            child: courseId.isEmpty
                ? const Center(child: Text("Course info is missing."))
                : StreamBuilder<List<Comment>>(
              stream: dataProvider.getCourseCommentsStream(courseId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                final comments = snapshot.data ?? [];
                if (comments.isEmpty) return const Center(child: Text("No reviews yet."));

                return ListView.separated(
                  padding: const EdgeInsets.all(16), itemCount: comments.length,
                  separatorBuilder: (context, index) => const Divider(height: 30),
                  itemBuilder: (context, index) {
                    final c = comments[index];
                    final uid = authProvider.user?.uid;
                    return _CommentCard(
                      author: c.authorName, date: _formatDate(c.createdAt), comment: c.text,
                      likeCount: c.likeCount, dislikeCount: c.dislikeCount, rating: c.rating, // ✅ Rating artık Comment'te var
                      isLiked: uid != null && c.likedBy.contains(uid),
                      isDisliked: uid != null && c.dislikedBy.contains(uid),
                      onLike: () => _handleReaction(context, courseId, c.id, true),
                      onDislike: () => _handleReaction(context, courseId, c.id, false),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleReaction(BuildContext context, String courseId, String commentId, bool isLike) {
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      context.read<DataProvider>().reactToCourseComment(courseId: courseId, commentId: commentId, userId: user.uid, isLike: isLike);
    }
  }

  String _formatDate(DateTime date) {
    if (date.millisecondsSinceEpoch == 0) return "";
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}

class _CommentCard extends StatelessWidget {
  final String author, date, comment;
  final int likeCount, dislikeCount;
  final double rating;
  final bool isLiked, isDisliked;
  final VoidCallback onLike, onDislike;

  const _CommentCard({
    required this.author, required this.date, required this.comment,
    required this.likeCount, required this.dislikeCount, required this.rating,
    required this.isLiked, required this.isDisliked, required this.onLike, required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 20, backgroundColor: Colors.grey[300], child: Text(author.isNotEmpty ? author[0].toUpperCase() : '?', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004990)))),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ]),
            if (rating > 0) ...[
              const SizedBox(height: 2),
              Row(children: [const Icon(Icons.star, size: 14, color: Colors.amber), Text(" ${rating.toStringAsFixed(1)}", style: const TextStyle(fontSize: 12, color: Colors.grey))]),
            ],
            const SizedBox(height: 5),
            Text(comment, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              InkWell(onTap: onLike, child: Row(children: [Icon(isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined, size: 18, color: isLiked ? const Color(0xFF0D47A1) : Colors.grey), const SizedBox(width: 4), Text("$likeCount")])),
              const SizedBox(width: 15),
              InkWell(onTap: onDislike, child: Row(children: [Icon(isDisliked ? Icons.thumb_down_alt : Icons.thumb_down_alt_outlined, size: 18, color: isDisliked ? Colors.redAccent : Colors.grey), const SizedBox(width: 4), Text("$dislikeCount")])),
            ]),
          ]),
        ),
      ],
    );
  }
}