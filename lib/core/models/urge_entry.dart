import 'package:hive/hive.dart';

part 'urge_entry.g.dart';

@HiveType(typeId: 11)
class UrgeEntry extends HiveObject {
  UrgeEntry({
    required this.id,
    required this.timestamp,
    required this.intensity,
    required this.trigger,
    this.note,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  /// Urge intensity from 1 (mild) to 10 (extreme).
  @HiveField(2)
  final int intensity;

  /// Trigger category: boredom, stress, loneliness, anxiety, habit,
  /// social_media, late_night, other.
  @HiveField(3)
  final String trigger;

  @HiveField(4)
  final String? note;

  UrgeEntry copyWith({
    String? id,
    DateTime? timestamp,
    int? intensity,
    String? trigger,
    String? note,
  }) {
    return UrgeEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      intensity: intensity ?? this.intensity,
      trigger: trigger ?? this.trigger,
      note: note ?? this.note,
    );
  }
}
