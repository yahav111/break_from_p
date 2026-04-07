import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'journal_entry.dart';

part 'journal_data.g.dart';

@HiveType(typeId: 10)
@JsonSerializable(explicitToJson: true)
class JournalData extends HiveObject {
  JournalData({
    this.entries = const [],
    this.updatedAt,
  });

  @HiveField(0)
  final List<JournalEntry> entries;

  @HiveField(1)
  final DateTime? updatedAt;

  factory JournalData.fromJson(Map<String, dynamic> json) =>
      _$JournalDataFromJson(json);
  Map<String, dynamic> toJson() => _$JournalDataToJson(this);

  JournalData copyWith({
    List<JournalEntry>? entries,
    DateTime? updatedAt,
  }) {
    return JournalData(
      entries: entries ?? this.entries,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
