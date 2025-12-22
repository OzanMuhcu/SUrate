import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String code;       // Örn: CS 201
  final String name;       // Örn: Introduction to Computing
  final String faculty;    // Örn: CS, EE
  final double rating;     // Örn: 4.5
  final String createdBy;  // Ekleyen kullanıcının ID'si (Zorunlu)
  final DateTime createdAt;// Oluşturulma tarihi (Zorunlu)

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.faculty,
    required this.rating,
    required this.createdBy,
    required this.createdAt,
  });

  // 1. Firebase'den gelen veriyi (Map) Uygulamaya (Class) çevirir
  factory Course.fromMap(Map<String, dynamic> map, String documentId) {
    return Course(
      id: documentId,
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      faculty: map['faculty'] ?? '',
      // Rating sayısal olduğu için double'a çevirirken dikkat ediyoruz
      rating: (map['rating'] ?? 0.0).toDouble(),
      createdBy: map['createdBy'] ?? '',
      // Timestamp'i DateTime'a çeviriyoruz
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // 2. Uygulamadaki veriyi (Class) Firebase'e (Map) çevirir
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