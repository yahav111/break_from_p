import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/notification_preferences_repository.dart';
import '../models/notification_preferences.dart';

/// Provided via ProviderScope.overrides at bootstrap.
final notifPrefsRepositoryProvider =
    Provider<NotificationPreferencesRepository>((ref) {
  throw UnimplementedError(
      'notifPrefsRepositoryProvider must be overridden');
});

final notifPrefsNotifierProvider =
    NotifierProvider<NotifPrefsNotifier, NotificationPreferences>(
        NotifPrefsNotifier.new);

class NotifPrefsNotifier extends Notifier<NotificationPreferences> {
  @override
  NotificationPreferences build() {
    final repo = ref.read(notifPrefsRepositoryProvider);
    return repo.get() ?? NotificationPreferences();
  }

  Future<void> updatePreferences(NotificationPreferences prefs) async {
    final repo = ref.read(notifPrefsRepositoryProvider);
    await repo.save(prefs);
    state = prefs;
  }

  Future<void> toggleMorningPledge(bool value) async {
    await updatePreferences(state.copyWith(morningPledgeEnabled: value));
  }

  Future<void> setMorningPledgeTime(int hour, int minute) async {
    await updatePreferences(
      state.copyWith(morningPledgeHour: hour, morningPledgeMinute: minute),
    );
  }

  Future<void> toggleMilestone(bool value) async {
    await updatePreferences(state.copyWith(milestoneEnabled: value));
  }

  Future<void> toggleDailyMotivation(bool value) async {
    await updatePreferences(state.copyWith(dailyMotivationEnabled: value));
  }

  Future<void> toggleEveningCheckIn(bool value) async {
    await updatePreferences(state.copyWith(eveningCheckInEnabled: value));
  }

  Future<void> setEveningCheckInTime(int hour, int minute) async {
    await updatePreferences(
      state.copyWith(eveningCheckInHour: hour, eveningCheckInMinute: minute),
    );
  }
}
