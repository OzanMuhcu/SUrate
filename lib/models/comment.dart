import 'firestore_helpers.dart';

class Comment {
  final String id;
  final String createdBy;
  final DateTime createdAt;
  final String courseId;
  final String authorName;
  final String text;
  final int likeCount;
  final int dislikeCount;
  final List<String> likedBy;
  final List<String> dislikedBy;

  const Comment({
    required this.id,
    required this.createdBy,
    required this.createdAt,
    required this.courseId,
    required this.authorName,
    required this.text,
    required this.likeCount,
    required this.dislikeCount,
    required this.likedBy,
    required this.dislikedBy,
  });

  factory Comment.fromFirestore(Map<String, dynamic> data, String id) {
    return Comment(
      id: data['id'] as String? ?? id,
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: parseCreatedAt(data['createdAt']),
      courseId: data['courseId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? '',
      text: data['text'] as String? ?? '',
      likeCount: (data['likeCount'] as num?)?.toInt() ?? 0,
      dislikeCount: (data['dislikeCount'] as num?)?.toInt() ?? 0,
      likedBy: _parseStringList(data['likedBy']),
      dislikedBy: _parseStringList(data['dislikedBy']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'courseId': courseId,
      'authorName': authorName,
      'text': text,
      'likeCount': likeCount,
      'dislikeCount': dislikeCount,
      'likedBy': likedBy,
      'dislikedBy': dislikedBy,
    };
  }

  static List<String> _parseStringList(Object? value) {
    if (value is Iterable) {
      return value.map((entry) => entry.toString()).toList();
    }
    return [];
  }
}
