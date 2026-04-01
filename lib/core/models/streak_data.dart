import 'package:hive/hive.dart';

import 'streak_record.dart';

part 'streak_data.g.dart';

@HiveType(typeId: 2)
class StreakData extends HiveObject {
  StreakData({
    required this.quitDate,
    this.longestStreakDays = 0,
    this.resetHistory = const [],
    this.streakHistory = const [],
  });

  @HiveField(0)
  final DateTime quitDate;

  @HiveField(1)
  final int longestStreakDays;

  /// Timestamps of each streak reset.
  @HiveField(2)
  final List<DateTime> resetHistory;

  /// Completed past streaks with start/end dates and duration.
  @HiveField(3)
  final List<StreakRecord> streakHistory;

  int get currentStreakDays => DateTime.now().difference(quitDate).inDays;

  StreakData copyWith({
    DateTime? quitDate,
    int? longestStreakDays,
    List<DateTime>? resetHistory,
    List<StreakRecord>? streakHistory,
  }) {
    return StreakData(
      quitDate: quitDate ?? this.quitDate,
      longestStreakDays: longestStreakDays ?? this.longestStreakDays,
      resetHistory: resetHistory ?? this.resetHistory,
      streakHistory: streakHistory ?? this.streakHistory,
    );
  }
}
