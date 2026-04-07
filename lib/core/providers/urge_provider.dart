import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/contracts/data_repository.dart';
import '../models/urge_data.dart';
import '../models/urge_entry.dart';

/// Provided via ProviderScope.overrides at bootstrap.
final urgeRepositoryProvider = Provider<DataRepository<UrgeData>>((ref) {
  throw UnimplementedError('urgeRepositoryProvider must be overridden');
});

final urgeNotifierProvider =
    NotifierProvider<UrgeNotifier, UrgeData?>(UrgeNotifier.new);

class UrgeNotifier extends Notifier<UrgeData?> {
  @override
  UrgeData? build() {
    final repo = ref.read(urgeRepositoryProvider);
    return repo.get();
  }

  Future<void> logUrge({
    required int intensity,
    required String trigger,
    String? note,
  }) async {
    final current = state ?? UrgeData();
    final now = DateTime.now();

    final entry = UrgeEntry(
      id: now.microsecondsSinceEpoch.toString(),
      timestamp: now,
      intensity: intensity,
      trigger: trigger,
      note: note,
    );

    final updated = UrgeData(
      entries: [entry, ...current.entries],
      totalUrges: current.totalUrges + 1,
    );

    final repo = ref.read(urgeRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }
}
