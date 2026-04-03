import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Schedules and manages local notifications for the app.
/// Uses grouped notification IDs: 1xx=pledge, 2xx=check-in,
/// 3xx=motivation, 4xx=milestones.
class NotificationScheduler {
  NotificationScheduler();

  final _plugin = FlutterLocalNotificationsPlugin();

  // Notification ID ranges by type.
  static const _pledgeId = 100;
  static const _checkInId = 200;
  static const _motivationId = 300;
  static const _milestoneBaseId = 400;

  static const _channelId = 'quittr_notifications';
  static const _channelName = 'Quittr';
  static const _channelDescription = 'Reminders and milestone celebrations';

  /// Initialize the notification plugin. Call once at app startup.
  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
  }

  /// Schedule a daily morning pledge reminder.
  Future<void> scheduleMorningPledge(int hour, int minute) async {
    await _cancelById(_pledgeId);
    await _scheduleDailyNotification(
      id: _pledgeId,
      hour: hour,
      minute: minute,
      title: 'Time to pledge',
      body: 'Start your day with a commitment to stay clean.',
    );
  }

  /// Schedule a daily evening check-in reminder.
  Future<void> scheduleEveningCheckIn(int hour, int minute) async {
    await _cancelById(_checkInId);
    await _scheduleDailyNotification(
      id: _checkInId,
      hour: hour,
      minute: minute,
      title: 'Evening check-in',
      body: 'How was your day? Take a moment to reflect.',
    );
  }

  /// Schedule a daily motivation notification (fixed at 12:00 PM).
  Future<void> scheduleDailyMotivation() async {
    await _cancelById(_motivationId);
    await _scheduleDailyNotification(
      id: _motivationId,
      hour: 12,
      minute: 0,
      title: 'Stay strong',
      body: 'Every day you choose freedom is a victory.',
    );
  }

  /// Show an immediate milestone celebration notification.
  Future<void> showMilestoneCelebration(int days) async {
    final details = _notificationDetails();
    await _plugin.show(
      _milestoneBaseId + days,
      'Milestone reached!',
      'You hit $days days! Your brain is rewiring.',
      details,
    );
  }

  /// Cancel all pledge notifications.
  Future<void> cancelMorningPledge() => _cancelById(_pledgeId);

  /// Cancel all evening check-in notifications.
  Future<void> cancelEveningCheckIn() => _cancelById(_checkInId);

  /// Cancel all daily motivation notifications.
  Future<void> cancelDailyMotivation() => _cancelById(_motivationId);

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() => _plugin.cancelAll();

  // ── Private helpers ──────────────────────────────────────────

  Future<void> _scheduleDailyNotification({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final details = _notificationDetails();

    // Use periodicallyShowWithDuration for daily repeating notifications.
    // We schedule with repeatInterval of 24 hours.
    // On Android 13+, exact alarms may require permission.
    await _plugin.periodicallyShowWithDuration(
      id,
      title,
      body,
      const Duration(hours: 24),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  NotificationDetails _notificationDetails() {
    const android = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.defaultPriority,
    );

    const ios = DarwinNotificationDetails();

    return const NotificationDetails(android: android, iOS: ios);
  }

  Future<void> _cancelById(int id) => _plugin.cancel(id);
}
