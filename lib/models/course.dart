import 'firestore_helpers.dart';

class Course {
  final String id;
  final String createdBy;
  final DateTime createdAt;
  final String code;
  final String name;
  final String faculty;
  final String major; // CS, EE, ME, BIO...
  final double rating;

  const Course({
    required this.id,
    required this.createdBy,
    required this.createdAt,
    required this.code,
    required this.name,
    required this.faculty,
    required this.major,
    required this.rating,
  });

  factory Course.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return Course(
      id: id,
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: parseCreatedAt(data['createdAt']),
      code: data['code'] as String? ?? '',
      name: data['name'] as String? ?? '',
      faculty: data['faculty'] as String? ?? '',
      major: data['major'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdBy': createdBy,
      'createdAt': createdAt,
      'code': code,
      'name': name,
      'faculty': faculty,
      'major': major,
      'rating': rating,
    };
  }
}
