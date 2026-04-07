import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'achievement_entry.dart';

part 'achievement_data.g.dart';

/// Container for all unlocked achievements.
@HiveType(typeId: 16)
@JsonSerializable(explicitToJson: true)
class AchievementData extends HiveObject {
  AchievementData({
    this.entries = const [],
    this.updatedAt,
  });

  @HiveField(0)
  final List<AchievementEntry> entries;

  @HiveField(1)
  final DateTime? updatedAt;

  factory AchievementData.fromJson(Map<String, dynamic> json) =>
      _$AchievementDataFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementDataToJson(this);

  AchievementData copyWith({
    List<AchievementEntry>? entries,
    DateTime? updatedAt,
  }) {
    return AchievementData(
      entries: entries ?? this.entries,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
