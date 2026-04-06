import 'package:hive/hive.dart';

import 'achievement_entry.dart';

part 'achievement_data.g.dart';

/// Container for all unlocked achievements.
@HiveType(typeId: 16)
class AchievementData extends HiveObject {
  AchievementData({
    this.entries = const [],
  });

  @HiveField(0)
  final List<AchievementEntry> entries;

  AchievementData copyWith({
    List<AchievementEntry>? entries,
  }) {
    return AchievementData(
      entries: entries ?? this.entries,
    );
  }
}
