import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/reasons_repository.dart';
import '../models/reasons_data.dart';

/// Provided via ProviderScope.overrides at bootstrap.
final reasonsRepositoryProvider = Provider<ReasonsRepository>((ref) {
  throw UnimplementedError('reasonsRepositoryProvider must be overridden');
});

final reasonsNotifierProvider =
    NotifierProvider<ReasonsNotifier, ReasonsData?>(ReasonsNotifier.new);

class ReasonsNotifier extends Notifier<ReasonsData?> {
  @override
  ReasonsData? build() {
    final repo = ref.read(reasonsRepositoryProvider);
    return repo.get();
  }

  Future<void> addReason(String reason) async {
    final current = state ?? ReasonsData();
    final updated = current.copyWith(
      reasons: [...current.reasons, reason],
    );
    final repo = ref.read(reasonsRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }

  Future<void> removeReason(int index) async {
    final current = state;
    if (current == null || index >= current.reasons.length) return;
    final reasons = List<String>.from(current.reasons)..removeAt(index);
    final updated = current.copyWith(reasons: reasons);
    final repo = ref.read(reasonsRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }

  Future<void> updateReason(int index, String newText) async {
    final current = state;
    if (current == null || index >= current.reasons.length) return;
    final reasons = List<String>.from(current.reasons)..[index] = newText;
    final updated = current.copyWith(reasons: reasons);
    final repo = ref.read(reasonsRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }

  Future<void> reorderReasons(int oldIndex, int newIndex) async {
    final current = state;
    if (current == null) return;
    final reasons = List<String>.from(current.reasons);
    final item = reasons.removeAt(oldIndex);
    final adjustedIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    reasons.insert(adjustedIndex, item);
    final updated = current.copyWith(reasons: reasons);
    final repo = ref.read(reasonsRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }
}
