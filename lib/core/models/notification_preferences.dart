import 'package:hive/hive.dart';

part 'notification_preferences.g.dart';

@HiveType(typeId: 7)
class NotificationPreferences extends HiveObject {
  NotificationPreferences({
    this.morningPledgeEnabled = true,
    this.morningPledgeHour = 8,
    this.morningPledgeMinute = 0,
    this.milestoneEnabled = true,
    this.dailyMotivationEnabled = true,
    this.eveningCheckInEnabled = true,
    this.eveningCheckInHour = 21,
    this.eveningCheckInMinute = 0,
  });

  @HiveField(0)
  final bool morningPledgeEnabled;

  @HiveField(1)
  final int morningPledgeHour;

  @HiveField(2)
  final int morningPledgeMinute;

  @HiveField(3)
  final bool milestoneEnabled;

  @HiveField(4)
  final bool dailyMotivationEnabled;

  @HiveField(5)
  final bool eveningCheckInEnabled;

  @HiveField(6)
  final int eveningCheckInHour;

  @HiveField(7)
  final int eveningCheckInMinute;

  NotificationPreferences copyWith({
    bool? morningPledgeEnabled,
    int? morningPledgeHour,
    int? morningPledgeMinute,
    bool? milestoneEnabled,
    bool? dailyMotivationEnabled,
    bool? eveningCheckInEnabled,
    int? eveningCheckInHour,
    int? eveningCheckInMinute,
  }) {
    return NotificationPreferences(
      morningPledgeEnabled: morningPledgeEnabled ?? this.morningPledgeEnabled,
      morningPledgeHour: morningPledgeHour ?? this.morningPledgeHour,
      morningPledgeMinute: morningPledgeMinute ?? this.morningPledgeMinute,
      milestoneEnabled: milestoneEnabled ?? this.milestoneEnabled,
      dailyMotivationEnabled:
          dailyMotivationEnabled ?? this.dailyMotivationEnabled,
      eveningCheckInEnabled:
          eveningCheckInEnabled ?? this.eveningCheckInEnabled,
      eveningCheckInHour: eveningCheckInHour ?? this.eveningCheckInHour,
      eveningCheckInMinute: eveningCheckInMinute ?? this.eveningCheckInMinute,
    );
  }
}
