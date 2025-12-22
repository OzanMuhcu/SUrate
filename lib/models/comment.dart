import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String text;
  final String createdBy;
  final String authorName;
  final String courseId;
  final DateTime createdAt;
  final int likeCount;
  final int dislikeCount;
  final List<String> likedBy;
  final List<String> dislikedBy;
  final double rating; // ✅ EKLENDİ

  Comment({
    required this.id,
    required this.text,
    required this.createdBy,
    required this.authorName,
    required this.courseId,
    required this.createdAt,
    required this.likeCount,
    required this.dislikeCount,
    required this.likedBy,
    required this.dislikedBy,
    this.rating = 0.0, // ✅ Varsayılan değer
  });

  factory Comment.fromFirestore(Map<String, dynamic> data, String id) {
    return Comment(
      id: id,
      text: data['text'] as String? ?? '',
      createdBy: data['createdBy'] as String? ?? '',
      authorName: data['authorName'] as String? ?? 'Anonymous',
      courseId: data['courseId'] as String? ?? '',
      createdAt: _parseCreatedAt(data['createdAt']),
      likeCount: (data['likeCount'] as num?)?.toInt() ?? 0,
      dislikeCount: (data['dislikeCount'] as num?)?.toInt() ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      dislikedBy: List<String>.from(data['dislikedBy'] ?? []),
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0, // ✅ EKLENDİ
    );
  }

  static DateTime _parseCreatedAt(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}