import 'package:hive/hive.dart';

part 'relapse_entry.g.dart';

@HiveType(typeId: 5)
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
