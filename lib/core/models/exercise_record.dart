import 'package:hive/hive.dart';

part 'exercise_record.g.dart';

@HiveType(typeId: 13)
class ExerciseRecord extends HiveObject {
  ExerciseRecord({
    required this.id,
    required this.completedAt,
    required this.exerciseType,
    required this.durationSeconds,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime completedAt;

  /// Exercise type: breathing, urge_surfing, grounding.
  @HiveField(2)
  final String exerciseType;

  @HiveField(3)
  final int durationSeconds;

  ExerciseRecord copyWith({
    String? id,
    DateTime? completedAt,
    String? exerciseType,
    int? durationSeconds,
  }) {
    return ExerciseRecord(
      id: id ?? this.id,
      completedAt: completedAt ?? this.completedAt,
      exerciseType: exerciseType ?? this.exerciseType,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }
}
