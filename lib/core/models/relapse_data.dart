import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'relapse_entry.dart';

part 'relapse_data.g.dart';

@HiveType(typeId: 4)
@JsonSerializable(explicitToJson: true)
class RelapseData extends HiveObject {
  RelapseData({
    this.totalRelapses = 0,
    this.relapseHistory = const [],
    this.updatedAt,
  });

  /// Lifetime relapse counter. Only resets via "Delete all data".
  @HiveField(0)
  final int totalRelapses;

  /// Detailed history of each relapse.
  @HiveField(1)
  final List<RelapseEntry> relapseHistory;

  @HiveField(2)
  final DateTime? updatedAt;

  factory RelapseData.fromJson(Map<String, dynamic> json) =>
      _$RelapseDataFromJson(json);
  Map<String, dynamic> toJson() => _$RelapseDataToJson(this);

  RelapseData copyWith({
    int? totalRelapses,
    List<RelapseEntry>? relapseHistory,
    DateTime? updatedAt,
  }) {
    return RelapseData(
      totalRelapses: totalRelapses ?? this.totalRelapses,
      relapseHistory: relapseHistory ?? this.relapseHistory,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
