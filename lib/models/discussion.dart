import 'firestore_helpers.dart';

class Discussion {
  final String id;
  final String createdBy;
  final DateTime createdAt;
  final String courseId;
  final String creatorName;
  final String title;
  final String body;

  const Discussion({
    required this.id,
    required this.createdBy,
    required this.createdAt,
    required this.courseId,
    required this.creatorName,
    required this.title,
    required this.body,
  });

  factory Discussion.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return Discussion(
      id: id,
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: parseCreatedAt(data['createdAt']),
      courseId: data['courseId'] as String? ?? '',
      creatorName: data['creatorName'] as String? ?? '',
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdBy': createdBy,
      'createdAt': createdAt,
      'courseId': courseId,
      'creatorName': creatorName,
      'title': title,
      'body': body,
    };
  }
}
