import 'package:hive/hive.dart';

import 'relapse_entry.dart';

part 'relapse_data.g.dart';

@HiveType(typeId: 4)
class RelapseData extends HiveObject {
  RelapseData({
    this.totalRelapses = 0,
    this.relapseHistory = const [],
  });

  /// Lifetime relapse counter. Only resets via "Delete all data".
  @HiveField(0)
  final int totalRelapses;

  /// Detailed history of each relapse.
  @HiveField(1)
  final List<RelapseEntry> relapseHistory;

  RelapseData copyWith({
    int? totalRelapses,
    List<RelapseEntry>? relapseHistory,
  }) {
    return RelapseData(
      totalRelapses: totalRelapses ?? this.totalRelapses,
      relapseHistory: relapseHistory ?? this.relapseHistory,
    );
  }
}
