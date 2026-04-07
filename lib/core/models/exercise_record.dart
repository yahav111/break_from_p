import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exercise_record.g.dart';

@HiveType(typeId: 13)
@JsonSerializable()
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

  factory ExerciseRecord.fromJson(Map<String, dynamic> json) =>
      _$ExerciseRecordFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseRecordToJson(this);

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
