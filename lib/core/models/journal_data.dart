import 'package:hive/hive.dart';

import 'journal_entry.dart';

part 'journal_data.g.dart';

@HiveType(typeId: 10)
class JournalData extends HiveObject {
  JournalData({
    this.entries = const [],
  });

  @HiveField(0)
  final List<JournalEntry> entries;

  JournalData copyWith({
    List<JournalEntry>? entries,
  }) {
    return JournalData(
      entries: entries ?? this.entries,
    );
  }
}
