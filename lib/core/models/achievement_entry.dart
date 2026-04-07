import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'achievement_entry.g.dart';

/// A single unlocked achievement with its unlock timestamp.
@HiveType(typeId: 15)
@JsonSerializable()
class AchievementEntry extends HiveObject {
  AchievementEntry({
    required this.id,
    required this.unlockedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime unlockedAt;

  factory AchievementEntry.fromJson(Map<String, dynamic> json) =>
      _$AchievementEntryFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementEntryToJson(this);
}
