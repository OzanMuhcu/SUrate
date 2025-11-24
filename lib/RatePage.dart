import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateCoursePage extends StatefulWidget {
  const RateCoursePage({super.key});

  @override
  State<RateCoursePage> createState() => _RateCoursePageState();
}

class _RateCoursePageState extends State<RateCoursePage> {
  double courseDifficulty = 3.0;
  double midtermDifficulty = 3.0;
  double finalDifficulty = 3.0;
  double projectDifficulty = 3.0;
  bool hasProject = false;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004990),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Geri dön (İptal)
        ),
        title: const Text(
          "Rate Course",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "How difficult was the course?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildRatingBar(
                  (rating) => setState(() => courseDifficulty = rating),
                ),

                const SizedBox(height: 16),
                const Text(
                  "How difficult was the midterm?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildRatingBar(
                  (rating) => setState(() => midtermDifficulty = rating),
                ),

                const SizedBox(height: 16),
                const Text(
                  "How difficult was the final?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildRatingBar(
                  (rating) => setState(() => finalDifficulty = rating),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Is there a project?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: hasProject,
                      activeColor: const Color(0xFF004990),
                      onChanged: (value) {
                        setState(() {
                          hasProject = value;
                        });
                      },
                    ),
                  ],
                ),

                if (hasProject) ...[
                  const SizedBox(height: 8),
                  const Text(
                    "How difficult was the project?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildRatingBar(
                    (rating) => setState(() => projectDifficulty = rating),
                  ),
                ],

                const SizedBox(height: 24),

                TextField(
                  controller: commentController,
                  maxLines: 4,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    hintText: "Write your opinion here...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF004990),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        Navigator.pop(context, {
                          'author': 'You', // Şimdilik sabit isim
                          'date': 'Just Now', // Şimdilik sabit tarih
                          'comment': commentController.text,
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004990),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBar(ValueChanged<double> onUpdate) {
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: onUpdate,
    );
  }
}
