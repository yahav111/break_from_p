import 'package:hive/hive.dart';

part 'achievement_entry.g.dart';

/// A single unlocked achievement with its unlock timestamp.
@HiveType(typeId: 15)
class AchievementEntry extends HiveObject {
  AchievementEntry({
    required this.id,
    required this.unlockedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime unlockedAt;
}
