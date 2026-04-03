import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/app_state_repository.dart';
import '../models/app_state.dart';

/// Provided via ProviderScope.overrides at bootstrap.
final appStateRepositoryProvider = Provider<AppStateRepository>((ref) {
  throw UnimplementedError('appStateRepositoryProvider must be overridden');
});

final appStateNotifierProvider =
    NotifierProvider<AppStateNotifier, AppState>(AppStateNotifier.new);

class AppStateNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    final repo = ref.read(appStateRepositoryProvider);
    return repo.load();
  }

  Future<void> completeOnboarding() async {
    final repo = ref.read(appStateRepositoryProvider);
    await repo.completeOnboarding();
    state = state.copyWith(onboardingCompleted: true, firstLaunch: false);
  }

  Future<void> celebrateMilestone(int days) async {
    final repo = ref.read(appStateRepositoryProvider);
    final updated = state.copyWith(lastCelebratedMilestone: days);
    await repo.save(updated);
    state = updated;
  }

  Future<void> resetAllState() async {
    final repo = ref.read(appStateRepositoryProvider);
    const fresh = AppState();
    await repo.save(fresh);
    state = fresh;
  }
}
