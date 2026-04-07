import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'streak_record.g.dart';

@HiveType(typeId: 8)
@JsonSerializable()
class StreakRecord extends HiveObject {
  StreakRecord({
    required this.startDate,
    required this.endDate,
    required this.days,
  });

  @HiveField(0)
  final DateTime startDate;

  @HiveField(1)
  final DateTime endDate;

  @HiveField(2)
  final int days;

  factory StreakRecord.fromJson(Map<String, dynamic> json) =>
      _$StreakRecordFromJson(json);
  Map<String, dynamic> toJson() => _$StreakRecordToJson(this);

  StreakRecord copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? days,
  }) {
    return StreakRecord(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      days: days ?? this.days,
    );
  }
}
