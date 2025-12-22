import 'firestore_helpers.dart';

class Rating {
  final String id;
  final String createdBy;
  final DateTime createdAt;
  final String courseId;
  final double courseDifficulty;
  final double midtermDifficulty;
  final double finalDifficulty;
  final bool hasProject;
  final double? projectDifficulty;

  const Rating({
    required this.id,
    required this.createdBy,
    required this.createdAt,
    required this.courseId,
    required this.courseDifficulty,
    required this.midtermDifficulty,
    required this.finalDifficulty,
    required this.hasProject,
    required this.projectDifficulty,
  });

  factory Rating.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return Rating(
      id: id,
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: parseCreatedAt(data['createdAt']),
      courseId: data['courseId'] as String? ?? '',
      courseDifficulty: (data['courseDifficulty'] as num?)?.toDouble() ?? 0.0,
      midtermDifficulty: (data['midtermDifficulty'] as num?)?.toDouble() ?? 0.0,
      finalDifficulty: (data['finalDifficulty'] as num?)?.toDouble() ?? 0.0,
      hasProject: data['hasProject'] as bool? ?? false,
      projectDifficulty:
      (data['projectDifficulty'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdBy': createdBy,
      'createdAt': createdAt,
      'courseId': courseId,
      'courseDifficulty': courseDifficulty,
      'midtermDifficulty': midtermDifficulty,
      'finalDifficulty': finalDifficulty,
      'hasProject': hasProject,
      'projectDifficulty': projectDifficulty,
    };
  }
}
