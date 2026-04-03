import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/streak_repository.dart';
import '../models/streak_data.dart';
import '../models/streak_record.dart';
import '../services/streak_engine.dart';

/// Provided via ProviderScope.overrides at bootstrap.
final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  throw UnimplementedError('streakRepositoryProvider must be overridden');
});

final streakNotifierProvider =
    NotifierProvider<StreakNotifier, StreakData?>(StreakNotifier.new);

class StreakNotifier extends Notifier<StreakData?> {
  @override
  StreakData? build() {
    final repo = ref.read(streakRepositoryProvider);
    return repo.get();
  }

  Future<void> startStreak(DateTime quitDate) async {
    final data = StreakData(quitDate: quitDate);
    final repo = ref.read(streakRepositoryProvider);
    await repo.save(data);
    state = data;
  }

  Future<void> resetStreak() async {
    final current = state;
    if (current == null) return;

    final now = DateTime.now();
    final currentDays = StreakEngine.daysSince(current.quitDate);
    final newLongest =
        StreakEngine.longestStreak(currentDays, current.longestStreakDays);

    // Record the completed streak in history.
    final record = StreakRecord(
      startDate: current.quitDate,
      endDate: now,
      days: currentDays,
    );

    final updated = StreakData(
      quitDate: now,
      longestStreakDays: newLongest,
      resetHistory: [...current.resetHistory, now],
      streakHistory: [...current.streakHistory, record],
    );

    final repo = ref.read(streakRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }
}
