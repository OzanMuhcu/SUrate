import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surate/models/comment.dart';
import 'package:surate/providers/auth_provider.dart';
import 'package:surate/providers/data_provider.dart';
import 'RatePage.dart';

class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> courseData;

  const CourseDetailPage({super.key, required this.courseData});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  @override
  Widget build(BuildContext context) {
    final String courseCode = widget.courseData['code'] ?? "CS 101";
    final double rating = (widget.courseData['rating'] is num)
        ? widget.courseData['rating'].toDouble()
        : 0.0;
    final String? courseId = widget.courseData['id'] as String?;
    final dataProvider = context.read<DataProvider>();
    final authProvider = context.watch<AuthProvider>();

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

          if (result is Map<String, String>) {
            final commentText = result['comment']?.trim();
            if (commentText == null || commentText.isEmpty) {
              return;
            }

            if (courseId == null || courseId.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Course info is missing.")),
              );
              return;
            }

            final user = authProvider.user;
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("You must be logged in to comment.")),
              );
              return;
            }

            await dataProvider.addCourseComment(
              courseId,
              commentText,
              user.uid,
              user.email?.split('@')[0] ?? "Anonymous",
            );

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
            child: courseId == null || courseId.isEmpty
                ? const Center(child: Text("Course info is missing."))
                : StreamBuilder<List<Comment>>(
              stream: dataProvider.getCourseCommentsStream(courseId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final comments = snapshot.data ?? [];
                if (comments.isEmpty) {
                  return const Center(
                    child: Text("No reviews yet. Be the first to review!"),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  separatorBuilder: (context, index) => const Divider(height: 30),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final userId = authProvider.user?.uid;
                    final isLiked = userId != null &&
                        comment.likedBy.contains(userId);
                    final isDisliked = userId != null &&
                        comment.dislikedBy.contains(userId);

                    return _CommentCard(
                      author: comment.authorName,
                      date: _formatDate(comment.createdAt),
                      comment: comment.text,
                      likeCount: comment.likeCount,
                      dislikeCount: comment.dislikeCount,
                      isLiked: isLiked,
                      isDisliked: isDisliked,
                      onLike: isLiked
                          ? null
                          : () => _handleReaction(
                        context,
                        courseId,
                        comment.id,
                        true,
                      ),
                      onDislike: isDisliked
                          ? null
                          : () => _handleReaction(
                        context,
                        courseId,
                        comment.id,
                        false,
                      ),
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

  void _handleReaction(
    BuildContext context,
    String courseId,
    String commentId,
    bool isLike,
  ) {
    final user = context.read<AuthProvider>().user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in to react.")),
      );
      return;
    }

    context.read<DataProvider>().reactToCourseComment(
      courseId: courseId,
      commentId: commentId,
      userId: user.uid,
      isLike: isLike,
    );
  }

  String _formatDate(DateTime date) {
    if (date.millisecondsSinceEpoch == 0) {
      return "";
    }
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return "$day/$month/$year $hour:$minute";
  }
}

class _CommentCard extends StatelessWidget {
  final String author;
  final String date;
  final String comment;
  final int likeCount;
  final int dislikeCount;
  final bool isLiked;
  final bool isDisliked;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;

  const _CommentCard({
    required this.author,
    required this.date,
    required this.comment,
    required this.likeCount,
    required this.dislikeCount,
    required this.isLiked,
    required this.isDisliked,
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
                          Icon(
                            isLiked
                                ? Icons.thumb_up_alt
                                : Icons.thumb_up_alt_outlined,
                            size: 18,
                            color: isLiked ? const Color(0xFF0D47A1) : Colors.grey,
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
                          Icon(
                            isDisliked
                                ? Icons.thumb_down_alt
                                : Icons.thumb_down_alt_outlined,
                            size: 18,
                            color: isDisliked ? Colors.redAccent : Colors.grey,
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
