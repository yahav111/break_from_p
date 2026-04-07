import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'urge_entry.dart';

part 'urge_data.g.dart';

@HiveType(typeId: 12)
@JsonSerializable(explicitToJson: true)
class UrgeData extends HiveObject {
  UrgeData({
    this.entries = const [],
    this.totalUrges = 0,
    this.updatedAt,
  });

  @HiveField(0)
  final List<UrgeEntry> entries;

  @HiveField(1)
  final int totalUrges;

  @HiveField(2)
  final DateTime? updatedAt;

  factory UrgeData.fromJson(Map<String, dynamic> json) =>
      _$UrgeDataFromJson(json);
  Map<String, dynamic> toJson() => _$UrgeDataToJson(this);

  UrgeData copyWith({
    List<UrgeEntry>? entries,
    int? totalUrges,
    DateTime? updatedAt,
  }) {
    return UrgeData(
      entries: entries ?? this.entries,
      totalUrges: totalUrges ?? this.totalUrges,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
