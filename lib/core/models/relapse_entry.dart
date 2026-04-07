import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'relapse_entry.g.dart';

@HiveType(typeId: 5)
@JsonSerializable()
class RelapseEntry extends HiveObject {
  RelapseEntry({
    required this.date,
    this.reason,
    required this.streakDaysLost,
  });

  @HiveField(0)
  final DateTime date;

  /// Optional reason the user provided for the relapse.
  @HiveField(1)
  final String? reason;

  /// How many days the streak was before this relapse.
  @HiveField(2)
  final int streakDaysLost;

  factory RelapseEntry.fromJson(Map<String, dynamic> json) =>
      _$RelapseEntryFromJson(json);
  Map<String, dynamic> toJson() => _$RelapseEntryToJson(this);

  RelapseEntry copyWith({
    DateTime? date,
    String? reason,
    int? streakDaysLost,
  }) {
    return RelapseEntry(
      date: date ?? this.date,
      reason: reason ?? this.reason,
      streakDaysLost: streakDaysLost ?? this.streakDaysLost,
    );
  }
}
