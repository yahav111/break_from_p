import 'package:hive/hive.dart';

import 'urge_entry.dart';

part 'urge_data.g.dart';

@HiveType(typeId: 12)
class UrgeData extends HiveObject {
  UrgeData({
    this.entries = const [],
    this.totalUrges = 0,
  });

  @HiveField(0)
  final List<UrgeEntry> entries;

  @HiveField(1)
  final int totalUrges;

  UrgeData copyWith({
    List<UrgeEntry>? entries,
    int? totalUrges,
  }) {
    return UrgeData(
      entries: entries ?? this.entries,
      totalUrges: totalUrges ?? this.totalUrges,
    );
  }
}
