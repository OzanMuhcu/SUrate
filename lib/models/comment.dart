class Comment {
  final String id;
  final String lectureId;
  final String author;
  final String text;
  final double rating;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.lectureId,
    required this.author,
    required this.text,
    required this.rating,
    required this.createdAt,
  });
}

