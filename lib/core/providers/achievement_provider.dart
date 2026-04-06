import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/achievement_repository.dart';
import '../models/achievement_data.dart';
import '../models/achievement_entry.dart';
import '../services/achievement_engine.dart';
import 'exercise_provider.dart';
import 'journal_provider.dart';
import 'lifetree_provider.dart';
import 'pledge_provider.dart';
import 'streak_provider.dart';
import 'urge_provider.dart';

/// Provided via ProviderScope.overrides at bootstrap.
final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  throw UnimplementedError('achievementRepositoryProvider must be overridden');
});

final achievementNotifierProvider =
    NotifierProvider<AchievementNotifier, AchievementData?>(
        AchievementNotifier.new);

class AchievementNotifier extends Notifier<AchievementData?> {
  @override
  AchievementData? build() {
    final repo = ref.read(achievementRepositoryProvider);
    return repo.get();
  }

  /// Set of already-unlocked achievement IDs.
  Set<String> get unlockedIds {
    final entries = state?.entries ?? [];
    return entries.map((e) => e.id).toSet();
  }

  /// Checks all achievement conditions and awards any newly earned.
  /// Returns the list of newly awarded achievement IDs.
  Future<List<String>> checkAndAward() async {
    final streakData = ref.read(streakNotifierProvider);
    final pledgeData = ref.read(pledgeNotifierProvider);
    final journalData = ref.read(journalNotifierProvider);
    final exerciseData = ref.read(exerciseNotifierProvider);
    final urgeData = ref.read(urgeNotifierProvider);
    final lifetreeData = ref.read(lifetreeNotifierProvider);

    final currentDays = streakData != null
        ? DateTime.now().difference(streakData.quitDate).inDays
        : 0;

    // Calculate pledge streak (consecutive days).
    final pledgeStreak = _pledgeStreak(pledgeData);

    // Calculate journal consecutive days.
    final journalConsecutive = _journalConsecutiveDays(journalData);

    // Collect exercise types.
    final exerciseTypes = <String>{};
    if (exerciseData != null) {
      for (final r in exerciseData.records) {
        exerciseTypes.add(r.exerciseType);
      }
    }

    final context = AchievementContext(
      currentStreakDays: currentDays,
      totalPledges: pledgeData?.pledgeDates.length ?? 0,
      currentPledgeStreak: pledgeStreak,
      totalJournalEntries: journalData?.entries.length ?? 0,
      journalConsecutiveDays: journalConsecutive,
      totalExercises: exerciseData?.totalCompleted ?? 0,
      exerciseTypes: exerciseTypes,
      totalUrges: urgeData?.totalUrges ?? 0,
      lifetreeNodesUnlocked: lifetreeData?.unlockedNodeIds.length ?? 0,
    );

    final newlyEarned = AchievementEngine.checkNewAchievements(
      alreadyUnlocked: unlockedIds,
      context: context,
    );

    if (newlyEarned.isEmpty) return [];

    final now = DateTime.now();
    final current = state ?? AchievementData();
    final newEntries = newlyEarned
        .map((id) => AchievementEntry(id: id, unlockedAt: now))
        .toList();

    final updated = current.copyWith(
      entries: [...current.entries, ...newEntries],
    );

    final repo = ref.read(achievementRepositoryProvider);
    await repo.save(updated);
    state = updated;

    return newlyEarned;
  }

  int _pledgeStreak(dynamic pledgeData) {
    if (pledgeData == null) return 0;
    final dates = List<DateTime>.from(pledgeData.pledgeDates)
      ..sort((a, b) => b.compareTo(a)); // newest first
    if (dates.isEmpty) return 0;

    var streak = 1;
    for (var i = 1; i < dates.length; i++) {
      final diff = dates[i - 1].difference(dates[i]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  int _journalConsecutiveDays(dynamic journalData) {
    if (journalData == null) return 0;
    final dates = journalData.entries
        .map<DateTime>((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // newest first
    if (dates.isEmpty) return 0;

    var streak = 1;
    for (var i = 1; i < dates.length; i++) {
      final diff = dates[i - 1].difference(dates[i]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}
