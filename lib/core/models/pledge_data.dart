import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pledge_data.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class PledgeData extends HiveObject {
  PledgeData({
    this.pledgeDates = const [],
    this.currentPledgeStreak = 0,
    this.longestPledgeStreak = 0,
    this.lastPledgeDate,
    this.updatedAt,
  });

  /// All dates on which the user made a pledge.
  @HiveField(0)
  final List<DateTime> pledgeDates;

  /// Current consecutive days of pledging.
  @HiveField(1)
  final int currentPledgeStreak;

  /// All-time longest pledge streak.
  @HiveField(2)
  final int longestPledgeStreak;

  /// Most recent pledge date (for streak calculation).
  @HiveField(3)
  final DateTime? lastPledgeDate;

  @HiveField(4)
  final DateTime? updatedAt;

  factory PledgeData.fromJson(Map<String, dynamic> json) =>
      _$PledgeDataFromJson(json);
  Map<String, dynamic> toJson() => _$PledgeDataToJson(this);

  PledgeData copyWith({
    List<DateTime>? pledgeDates,
    int? currentPledgeStreak,
    int? longestPledgeStreak,
    DateTime? lastPledgeDate,
    DateTime? updatedAt,
  }) {
    return PledgeData(
      pledgeDates: pledgeDates ?? this.pledgeDates,
      currentPledgeStreak: currentPledgeStreak ?? this.currentPledgeStreak,
      longestPledgeStreak: longestPledgeStreak ?? this.longestPledgeStreak,
      lastPledgeDate: lastPledgeDate ?? this.lastPledgeDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
