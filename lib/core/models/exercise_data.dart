import 'package:hive/hive.dart';

import 'exercise_record.dart';

part 'exercise_data.g.dart';

@HiveType(typeId: 14)
class ExerciseData extends HiveObject {
  ExerciseData({
    this.records = const [],
    this.totalCompleted = 0,
  });

  @HiveField(0)
  final List<ExerciseRecord> records;

  @HiveField(1)
  final int totalCompleted;

  ExerciseData copyWith({
    List<ExerciseRecord>? records,
    int? totalCompleted,
  }) {
    return ExerciseData(
      records: records ?? this.records,
      totalCompleted: totalCompleted ?? this.totalCompleted,
    );
  }
}
