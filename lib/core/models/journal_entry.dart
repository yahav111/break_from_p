import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 9)
class JournalEntry extends HiveObject {
  JournalEntry({
    required this.id,
    required this.date,
    required this.content,
    required this.mood,
    this.prompt,
    required this.createdAt,
    required this.updatedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String content;

  /// Mood value: 0=bad, 1=struggling, 2=okay, 3=good, 4=great.
  @HiveField(3)
  final int mood;

  /// Optional prompt text used for this entry.
  @HiveField(4)
  final String? prompt;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  JournalEntry copyWith({
    String? id,
    DateTime? date,
    String? content,
    int? mood,
    String? prompt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      prompt: prompt ?? this.prompt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
