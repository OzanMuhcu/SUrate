import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
// ÇAKIŞMAYI ÖNLEMEK İÇİN 'hide AuthProvider' EKLENDİ 👇
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'providers/data_provider.dart';
import 'providers/auth_provider.dart';

class RateCoursePage extends StatefulWidget {
  final String courseId;
  final String courseCode;

  const RateCoursePage({
    super.key,
    required this.courseId,
    required this.courseCode
  });

  @override
  State<RateCoursePage> createState() => _RateCoursePageState();
}

class _RateCoursePageState extends State<RateCoursePage> {
  double courseDifficulty = 3.0;
  double midtermDifficulty = 3.0;
  double finalDifficulty = 3.0;
  double projectDifficulty = 3.0;
  bool hasProject = false;

  bool _isSubmitting = false;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004990),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Rate ${widget.courseCode}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isSubmitting
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("How difficult was the course?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildRatingBar((r) => setState(() => courseDifficulty = r)),

              const SizedBox(height: 16),
              const Text("How difficult was the midterm?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildRatingBar((r) => setState(() => midtermDifficulty = r)),

              const SizedBox(height: 16),
              const Text("How difficult was the final?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildRatingBar((r) => setState(() => finalDifficulty = r)),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Is there a project?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Switch(
                    value: hasProject,
                    activeColor: const Color(0xFF004990),
                    onChanged: (v) => setState(() => hasProject = v),
                  ),
                ],
              ),

              if (hasProject) ...[
                const SizedBox(height: 8),
                const Text("How difficult was the project?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildRatingBar((r) => setState(() => projectDifficulty = r)),
              ],

              const SizedBox(height: 24),
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write your opinion here...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004990)),
                  child: const Text("Submit", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitReview() async {
    final String comment = commentController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please write a comment")));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      double sum = courseDifficulty + midtermDifficulty + finalDifficulty;
      int divisor = 3;
      if (hasProject) {
        sum += projectDifficulty;
        divisor = 4;
      }
      final double userRating = sum / divisor;

      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user == null) throw Exception("User not logged in");

      await dataProvider.submitCourseReview(
        courseId: widget.courseId,
        userId: user.uid,
        userName: user.displayName ?? "Anonymous",
        commentText: comment,
        userRating: userRating,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Review submitted!")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildRatingBar(ValueChanged<double> onUpdate) {
    return RatingBar.builder(
      initialRating: 3, minRating: 1, direction: Axis.horizontal, allowHalfRating: true,
      itemCount: 5, itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: onUpdate,
    );
  }
}