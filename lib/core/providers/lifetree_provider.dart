import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/lifetree_repository.dart';
import '../models/lifetree_data.dart';

/// Provided via ProviderScope.overrides at bootstrap.
final lifetreeRepositoryProvider = Provider<LifetreeRepository>((ref) {
  throw UnimplementedError('lifetreeRepositoryProvider must be overridden');
});

final lifetreeNotifierProvider =
    NotifierProvider<LifetreeNotifier, LifetreeData?>(LifetreeNotifier.new);

class LifetreeNotifier extends Notifier<LifetreeData?> {
  @override
  LifetreeData? build() {
    final repo = ref.read(lifetreeRepositoryProvider);
    return repo.get();
  }

  /// Whether a specific node is unlocked.
  bool isNodeUnlocked(String nodeId) {
    return state?.unlockedNodeIds.contains(nodeId) ?? false;
  }

  /// Number of unlocked nodes.
  int get unlockedCount => state?.unlockedNodeIds.length ?? 0;

  /// Set of unlocked node IDs.
  Set<String> get unlockedNodeIds =>
      state?.unlockedNodeIds.toSet() ?? <String>{};

  /// Unlock a node by ID.
  Future<void> unlockNode(String nodeId) async {
    final current = state ?? LifetreeData();
    if (current.unlockedNodeIds.contains(nodeId)) return;

    final updated = current.copyWith(
      unlockedNodeIds: [...current.unlockedNodeIds, nodeId],
    );

    final repo = ref.read(lifetreeRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }
}
