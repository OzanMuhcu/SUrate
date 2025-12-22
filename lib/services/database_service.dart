import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String code;
  final String name;
  final String faculty;
  final double rating;
  final String createdBy;
  final DateTime createdAt;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.faculty,
    required this.rating,
    required this.createdBy,
    required this.createdAt,
  });

  factory Course.fromMap(Map<String, dynamic> map, String documentId) {
    return Course(
      id: documentId,
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      faculty: map['faculty'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'faculty': faculty,
      'rating': rating,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}