import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'exercise_record.dart';

part 'exercise_data.g.dart';

@HiveType(typeId: 14)
@JsonSerializable(explicitToJson: true)
class ExerciseData extends HiveObject {
  ExerciseData({
    this.records = const [],
    this.totalCompleted = 0,
    this.updatedAt,
  });

  @HiveField(0)
  final List<ExerciseRecord> records;

  @HiveField(1)
  final int totalCompleted;

  @HiveField(2)
  final DateTime? updatedAt;

  factory ExerciseData.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDataFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseDataToJson(this);

  ExerciseData copyWith({
    List<ExerciseRecord>? records,
    int? totalCompleted,
    DateTime? updatedAt,
  }) {
    return ExerciseData(
      records: records ?? this.records,
      totalCompleted: totalCompleted ?? this.totalCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
