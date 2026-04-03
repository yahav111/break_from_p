import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/relapse_repository.dart';
import '../models/relapse_data.dart';
import '../models/relapse_entry.dart';

/// Provided via ProviderScope.overrides at bootstrap.
final relapseRepositoryProvider = Provider<RelapseRepository>((ref) {
  throw UnimplementedError('relapseRepositoryProvider must be overridden');
});

final relapseNotifierProvider =
    NotifierProvider<RelapseNotifier, RelapseData?>(RelapseNotifier.new);

class RelapseNotifier extends Notifier<RelapseData?> {
  @override
  RelapseData? build() {
    final repo = ref.read(relapseRepositoryProvider);
    return repo.get();
  }

  /// Records a relapse with optional reason and the streak days lost.
  Future<void> recordRelapse({
    String? reason,
    required int streakDaysLost,
  }) async {
    final current = state ?? RelapseData();

    final entry = RelapseEntry(
      date: DateTime.now(),
      reason: reason,
      streakDaysLost: streakDaysLost,
    );

    final updated = RelapseData(
      totalRelapses: current.totalRelapses + 1,
      relapseHistory: [...current.relapseHistory, entry],
    );

    final repo = ref.read(relapseRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }
}
