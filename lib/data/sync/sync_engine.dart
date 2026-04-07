import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/auth/auth_provider.dart';
import '../../infrastructure/connectivity/connectivity_provider.dart';
import '../../infrastructure/firebase/firestore_paths.dart';
import '../repositories/firestore/firestore_achievement_repository.dart';
import '../repositories/firestore/firestore_exercise_repository.dart';
import '../repositories/firestore/firestore_journal_repository.dart';
import '../repositories/firestore/firestore_lifetree_repository.dart';
import '../repositories/firestore/firestore_pledge_repository.dart';
import '../repositories/firestore/firestore_reasons_repository.dart';
import '../repositories/firestore/firestore_relapse_repository.dart';
import '../repositories/firestore/firestore_streak_repository.dart';
import '../repositories/firestore/firestore_urge_repository.dart';
import '../repositories/firestore/firestore_user_profile_repository.dart';
import '../repositories/contracts/data_repository.dart';
import '../../core/models/achievement_data.dart';
import '../../core/models/exercise_data.dart';
import '../../core/models/journal_data.dart';
import '../../core/models/lifetree_data.dart';
import '../../core/models/pledge_data.dart';
import '../../core/models/reasons_data.dart';
import '../../core/models/relapse_data.dart';
import '../../core/models/streak_data.dart';
import '../../core/models/urge_data.dart';
import '../../core/models/user_profile.dart';
import '../../core/providers/achievement_provider.dart';
import '../../core/providers/exercise_provider.dart';
import '../../core/providers/journal_provider.dart';
import '../../core/providers/lifetree_provider.dart';
import '../../core/providers/pledge_provider.dart';
import '../../core/providers/reasons_provider.dart';
import '../../core/providers/relapse_provider.dart';
import '../../core/providers/streak_provider.dart';
import '../../core/providers/urge_provider.dart';
import '../../core/providers/user_profile_provider.dart';
import 'sync_status.dart';

final syncEngineProvider =
    NotifierProvider<SyncEngine, SyncStatus>(SyncEngine.new);

/// Orchestrates data synchronization between Hive and Firestore.
class SyncEngine extends Notifier<SyncStatus> {
  @override
  SyncStatus build() => const SyncStatus();

  /// One-time migration: pushes all local Hive data to Firestore.
  /// Called after first anonymous sign-in.
  Future<void> migrateLocalToCloud() async {
    final authState = ref.read(authNotifierProvider);
    final uid = authState.uid;
    if (uid == null) return;

    final isOnline = ref.read(isOnlineValueProvider);
    if (!isOnline) {
      state = state.copyWith(state: SyncState.offline);
      return;
    }

    state = state.copyWith(state: SyncState.syncing);

    try {
      final firestore = FirebaseFirestore.instance;

      // Check if migration was already done.
      final metaDoc = await firestore.doc(FirestorePaths.syncMeta(uid)).get();
      if (metaDoc.exists && metaDoc.data()?['migrationCompleted'] == true) {
        state = state.copyWith(
          state: SyncState.synced,
          migrationCompleted: true,
        );
        return;
      }

      // Read all local data and push to Firestore.
      await _pushRepo<UserProfile>(
        ref.read(userProfileRepositoryProvider),
        FirestoreUserProfileRepository(firestore, uid),
      );
      await _pushRepo<StreakData>(
        ref.read(streakRepositoryProvider),
        FirestoreStreakRepository(firestore, uid),
      );
      await _pushRepo<PledgeData>(
        ref.read(pledgeRepositoryProvider),
        FirestorePledgeRepository(firestore, uid),
      );
      await _pushRepo<RelapseData>(
        ref.read(relapseRepositoryProvider),
        FirestoreRelapseRepository(firestore, uid),
      );
      await _pushRepo<ReasonsData>(
        ref.read(reasonsRepositoryProvider),
        FirestoreReasonsRepository(firestore, uid),
      );
      await _pushRepo<JournalData>(
        ref.read(journalRepositoryProvider),
        FirestoreJournalRepository(firestore, uid),
      );
      await _pushRepo<UrgeData>(
        ref.read(urgeRepositoryProvider),
        FirestoreUrgeRepository(firestore, uid),
      );
      await _pushRepo<ExerciseData>(
        ref.read(exerciseRepositoryProvider),
        FirestoreExerciseRepository(firestore, uid),
      );
      await _pushRepo<AchievementData>(
        ref.read(achievementRepositoryProvider),
        FirestoreAchievementRepository(firestore, uid),
      );
      await _pushRepo<LifetreeData>(
        ref.read(lifetreeRepositoryProvider),
        FirestoreLifetreeRepository(firestore, uid),
      );

      // Mark migration as complete.
      await firestore.doc(FirestorePaths.syncMeta(uid)).set({
        'migrationCompleted': true,
        'lastSyncedAt': FieldValue.serverTimestamp(),
        'schemaVersion': 1,
      });

      state = state.copyWith(
        state: SyncState.synced,
        lastSyncedAt: DateTime.now(),
        migrationCompleted: true,
      );
    } catch (e) {
      state = state.copyWith(state: SyncState.error, error: e.toString());
    }
  }

  /// Pulls all data from Firestore into Hive.
  /// Used when signing in on a new device with existing cloud data.
  Future<void> pullFromCloud() async {
    final authState = ref.read(authNotifierProvider);
    final uid = authState.uid;
    if (uid == null) return;

    state = state.copyWith(state: SyncState.syncing);

    try {
      final firestore = FirebaseFirestore.instance;

      await _pullRepo(
        ref.read(userProfileRepositoryProvider),
        FirestoreUserProfileRepository(firestore, uid),
      );
      await _pullRepo(
        ref.read(streakRepositoryProvider),
        FirestoreStreakRepository(firestore, uid),
      );
      await _pullRepo(
        ref.read(pledgeRepositoryProvider),
        FirestorePledgeRepository(firestore, uid),
      );
      await _pullRepo(
        ref.read(relapseRepositoryProvider),
        FirestoreRelapseRepository(firestore, uid),
      );
      await _pullRepo(
        ref.read(reasonsRepositoryProvider),
        FirestoreReasonsRepository(firestore, uid),
      );
      await _pullRepo(
        ref.read(journalRepositoryProvider),
        FirestoreJournalRepository(firestore, uid),
      );
      await _pullRepo(
        ref.read(urgeRepositoryProvider),
        FirestoreUrgeRepository(firestore, uid),
      );
      await _pullRepo(
        ref.read(exerciseRepositoryProvider),
        FirestoreExerciseRepository(firestore, uid),
      );
      await _pullRepo(
        ref.read(achievementRepositoryProvider),
        FirestoreAchievementRepository(firestore, uid),
      );
      await _pullRepo(
        ref.read(lifetreeRepositoryProvider),
        FirestoreLifetreeRepository(firestore, uid),
      );

      state = state.copyWith(
        state: SyncState.synced,
        lastSyncedAt: DateTime.now(),
        migrationCompleted: true,
      );
    } catch (e) {
      state = state.copyWith(state: SyncState.error, error: e.toString());
    }
  }

  /// Pushes all current local data to Firestore.
  /// Called when connectivity is restored.
  Future<void> pushPendingChanges() async {
    // Re-run migration logic — it's idempotent and handles all repos.
    await migrateLocalToCloud();
  }

  Future<void> _pushRepo<T>(
    DataRepository<T> local,
    DataRepository<T> remote,
  ) async {
    final data = local.get();
    if (data != null) {
      await remote.save(data);
    }
  }

  Future<void> _pullRepo<T>(
    DataRepository<T> local,
    dynamic firestoreRepo,
  ) async {
    final T? data = await firestoreRepo.fetch() as T?;
    if (data != null) {
      await local.save(data);
    }
  }
}
