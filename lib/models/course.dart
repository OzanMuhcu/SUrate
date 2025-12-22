import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String createdBy;
  final DateTime createdAt;
  final String code;
  final String name;
  final String faculty;
  final String major;
  final double rating;
  final int ratingCount;

  const Course({
    required this.id,
    required this.createdBy,
    required this.createdAt,
    required this.code,
    required this.name,
    required this.faculty,
    required this.major,
    required this.rating,
    required this.ratingCount,
  });

  factory Course.fromFirestore(Map<String, dynamic> data, String id) {
    return Course(
      id: id,
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: _parseCreatedAt(data['createdAt']),
      code: data['code'] as String? ?? '',
      name: data['name'] as String? ?? '',
      faculty: data['faculty'] as String? ?? '',
      major: data['major'] as String? ?? '',

      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (data['ratingCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'code': code,
      'name': name,
      'faculty': faculty,
      'major': major,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }


  static DateTime _parseCreatedAt(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}