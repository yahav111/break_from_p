import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/contracts/data_repository.dart';
import '../models/pledge_data.dart';

/// Provided via ProviderScope.overrides at bootstrap.
final pledgeRepositoryProvider = Provider<DataRepository<PledgeData>>((ref) {
  throw UnimplementedError('pledgeRepositoryProvider must be overridden');
});

final pledgeNotifierProvider =
    NotifierProvider<PledgeNotifier, PledgeData?>(PledgeNotifier.new);

class PledgeNotifier extends Notifier<PledgeData?> {
  @override
  PledgeData? build() {
    final repo = ref.read(pledgeRepositoryProvider);
    return repo.get();
  }

  /// Whether the user has already pledged today.
  bool get hasPledgedToday {
    final data = state;
    if (data == null || data.lastPledgeDate == null) return false;
    final now = DateTime.now();
    final last = data.lastPledgeDate!;
    return last.year == now.year &&
        last.month == now.month &&
        last.day == now.day;
  }

  /// Records today's pledge and updates streak.
  Future<void> makePledge() async {
    if (hasPledgedToday) return;

    final now = DateTime.now();
    final current = state ?? PledgeData();

    // Calculate new streak.
    int newStreak = 1;
    if (current.lastPledgeDate != null) {
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      final lastDate = current.lastPledgeDate!;
      final wasYesterday = lastDate.year == yesterday.year &&
          lastDate.month == yesterday.month &&
          lastDate.day == yesterday.day;
      if (wasYesterday) {
        newStreak = current.currentPledgeStreak + 1;
      }
    }

    final longestStreak = newStreak > current.longestPledgeStreak
        ? newStreak
        : current.longestPledgeStreak;

    final updated = PledgeData(
      pledgeDates: [...current.pledgeDates, now],
      currentPledgeStreak: newStreak,
      longestPledgeStreak: longestStreak,
      lastPledgeDate: now,
    );

    final repo = ref.read(pledgeRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }
}
