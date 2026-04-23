import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/models/achievement_data.dart';
import 'core/models/achievement_entry.dart';
import 'core/models/exercise_data.dart';
import 'core/models/exercise_record.dart';
import 'core/models/journal_data.dart';
import 'core/models/journal_entry.dart';
import 'core/models/lifetree_data.dart';
import 'core/models/notification_preferences.dart';
import 'features/onboarding/models/onboarding_data.dart';
import 'core/models/pledge_data.dart';
import 'core/models/reasons_data.dart';
import 'core/models/relapse_data.dart';
import 'core/models/relapse_entry.dart';
import 'core/models/streak_data.dart';
import 'core/models/streak_record.dart';
import 'core/models/urge_data.dart';
import 'core/models/urge_entry.dart';
import 'core/models/user_profile.dart';
import 'core/providers/achievement_provider.dart';
import 'core/providers/app_state_provider.dart';
import 'core/providers/exercise_provider.dart';
import 'core/providers/journal_provider.dart';
import 'core/providers/lifetree_provider.dart';
import 'core/providers/notification_preferences_provider.dart';
import 'core/providers/pledge_provider.dart';
import 'core/providers/reasons_provider.dart';
import 'core/providers/relapse_provider.dart';
import 'core/providers/streak_provider.dart';
import 'core/providers/urge_provider.dart';
import 'core/providers/user_profile_provider.dart';
import 'data/repositories/app_state_repository.dart';
import 'data/repositories/contracts/data_repository.dart';
import 'data/repositories/firestore/firestore_achievement_repository.dart';
import 'data/repositories/firestore/firestore_exercise_repository.dart';
import 'data/repositories/firestore/firestore_journal_repository.dart';
import 'data/repositories/firestore/firestore_lifetree_repository.dart';
import 'data/repositories/firestore/firestore_pledge_repository.dart';
import 'data/repositories/firestore/firestore_reasons_repository.dart';
import 'data/repositories/firestore/firestore_relapse_repository.dart';
import 'data/repositories/firestore/firestore_streak_repository.dart';
import 'data/repositories/firestore/firestore_urge_repository.dart';
import 'data/repositories/firestore/firestore_user_profile_repository.dart';
import 'data/repositories/hive/hive_achievement_repository.dart';
import 'data/repositories/hive/hive_exercise_repository.dart';
import 'data/repositories/hive/hive_journal_repository.dart';
import 'data/repositories/hive/hive_lifetree_repository.dart';
import 'data/repositories/hive/hive_notification_preferences_repository.dart';
import 'data/repositories/hive/hive_pledge_repository.dart';
import 'data/repositories/hive/hive_reasons_repository.dart';
import 'data/repositories/hive/hive_relapse_repository.dart';
import 'data/repositories/hive/hive_streak_repository.dart';
import 'data/repositories/hive/hive_urge_repository.dart';
import 'data/repositories/hive/hive_user_profile_repository.dart';
import 'data/repositories/synced/synced_repository.dart';
import 'infrastructure/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await initializeDateFormatting('he_IL');

  // Initialize Firebase.
  await initializeFirebase();

  // Initialize Hive and register generated adapters.
  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(SubscriptionStatusAdapter());
  Hive.registerAdapter(StreakRecordAdapter());
  Hive.registerAdapter(StreakDataAdapter());
  Hive.registerAdapter(PledgeDataAdapter());
  Hive.registerAdapter(RelapseEntryAdapter());
  Hive.registerAdapter(RelapseDataAdapter());
  Hive.registerAdapter(ReasonsDataAdapter());
  Hive.registerAdapter(NotificationPreferencesAdapter());
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(JournalDataAdapter());
  Hive.registerAdapter(UrgeEntryAdapter());
  Hive.registerAdapter(UrgeDataAdapter());
  Hive.registerAdapter(ExerciseRecordAdapter());
  Hive.registerAdapter(ExerciseDataAdapter());
  Hive.registerAdapter(AchievementEntryAdapter());
  Hive.registerAdapter(AchievementDataAdapter());
  Hive.registerAdapter(LifetreeDataAdapter());
  Hive.registerAdapter(OnboardingDataAdapter());

  // Open boxes and SharedPreferences in parallel.
  final results = await Future.wait([
    Hive.openBox<UserProfile>('user_profile'),
    Hive.openBox<StreakData>('streak_data'),
    Hive.openBox<PledgeData>('pledge_data'),
    Hive.openBox<RelapseData>('relapse_data'),
    Hive.openBox<ReasonsData>('reasons_data'),
    Hive.openBox<NotificationPreferences>('notification_preferences'),
    SharedPreferences.getInstance(),
    Hive.openBox<JournalData>('journal_data'),
    Hive.openBox<UrgeData>('urge_data'),
    Hive.openBox<ExerciseData>('exercise_data'),
    Hive.openBox<AchievementData>('achievement_data'),
    Hive.openBox<LifetreeData>('lifetree_data'),
    Hive.openBox<OnboardingData>('onboarding_data'),
  ]);

  final userBox = results[0] as Box<UserProfile>;
  final streakBox = results[1] as Box<StreakData>;
  final pledgeBox = results[2] as Box<PledgeData>;
  final relapseBox = results[3] as Box<RelapseData>;
  final reasonsBox = results[4] as Box<ReasonsData>;
  final notifPrefsBox = results[5] as Box<NotificationPreferences>;
  final prefs = results[6] as SharedPreferences;
  final journalBox = results[7] as Box<JournalData>;
  final urgeBox = results[8] as Box<UrgeData>;
  final exerciseBox = results[9] as Box<ExerciseData>;
  final achievementBox = results[10] as Box<AchievementData>;
  final lifetreeBox = results[11] as Box<LifetreeData>;

  // Create Hive repositories (always the local cache).
  final hiveUserProfileRepo = HiveUserProfileRepository(userBox);
  final hiveStreakRepo = HiveStreakRepository(streakBox);
  final hivePledgeRepo = HivePledgeRepository(pledgeBox);
  final hiveRelapseRepo = HiveRelapseRepository(relapseBox);
  final hiveReasonsRepo = HiveReasonsRepository(reasonsBox);
  final hiveNotifPrefsRepo = HiveNotificationPreferencesRepository(notifPrefsBox);
  final hiveJournalRepo = HiveJournalRepository(journalBox);
  final hiveUrgeRepo = HiveUrgeRepository(urgeBox);
  final hiveExerciseRepo = HiveExerciseRepository(exerciseBox);
  final hiveAchievementRepo = HiveAchievementRepository(achievementBox);
  final hiveLifetreeRepo = HiveLifetreeRepository(lifetreeBox);
  final appStateRepo = AppStateRepository(prefs);

  // Check if user is already authenticated (app restart with existing session).
  final currentUser = FirebaseAuth.instance.currentUser;
  final uid = currentUser?.uid;

  // Build repository overrides — synced if authenticated, plain Hive otherwise.
  final DataRepository<UserProfile> userProfileRepo;
  final DataRepository<StreakData> streakRepo;
  final DataRepository<PledgeData> pledgeRepo;
  final DataRepository<RelapseData> relapseRepo;
  final DataRepository<ReasonsData> reasonsRepo;
  final DataRepository<JournalData> journalRepo;
  final DataRepository<UrgeData> urgeRepo;
  final DataRepository<ExerciseData> exerciseRepo;
  final DataRepository<AchievementData> achievementRepo;
  final DataRepository<LifetreeData> lifetreeRepo;

  if (uid != null) {
    final firestore = FirebaseFirestore.instance;
    bool isOnline() => true; // Refined by ConnectivityProvider at runtime.

    userProfileRepo = SyncedRepository<UserProfile>(
      local: hiveUserProfileRepo,
      remote: FirestoreUserProfileRepository(firestore, uid),
      isOnline: isOnline,
    );
    streakRepo = SyncedRepository<StreakData>(
      local: hiveStreakRepo,
      remote: FirestoreStreakRepository(firestore, uid),
      isOnline: isOnline,
    );
    pledgeRepo = SyncedRepository<PledgeData>(
      local: hivePledgeRepo,
      remote: FirestorePledgeRepository(firestore, uid),
      isOnline: isOnline,
    );
    relapseRepo = SyncedRepository<RelapseData>(
      local: hiveRelapseRepo,
      remote: FirestoreRelapseRepository(firestore, uid),
      isOnline: isOnline,
    );
    reasonsRepo = SyncedRepository<ReasonsData>(
      local: hiveReasonsRepo,
      remote: FirestoreReasonsRepository(firestore, uid),
      isOnline: isOnline,
    );
    journalRepo = SyncedRepository<JournalData>(
      local: hiveJournalRepo,
      remote: FirestoreJournalRepository(firestore, uid),
      isOnline: isOnline,
    );
    urgeRepo = SyncedRepository<UrgeData>(
      local: hiveUrgeRepo,
      remote: FirestoreUrgeRepository(firestore, uid),
      isOnline: isOnline,
    );
    exerciseRepo = SyncedRepository<ExerciseData>(
      local: hiveExerciseRepo,
      remote: FirestoreExerciseRepository(firestore, uid),
      isOnline: isOnline,
    );
    achievementRepo = SyncedRepository<AchievementData>(
      local: hiveAchievementRepo,
      remote: FirestoreAchievementRepository(firestore, uid),
      isOnline: isOnline,
    );
    lifetreeRepo = SyncedRepository<LifetreeData>(
      local: hiveLifetreeRepo,
      remote: FirestoreLifetreeRepository(firestore, uid),
      isOnline: isOnline,
    );
  } else {
    // Not authenticated yet — use plain Hive repos.
    // SyncedRepository instances will be created after anonymous sign-in.
    userProfileRepo = hiveUserProfileRepo;
    streakRepo = hiveStreakRepo;
    pledgeRepo = hivePledgeRepo;
    relapseRepo = hiveRelapseRepo;
    reasonsRepo = hiveReasonsRepo;
    journalRepo = hiveJournalRepo;
    urgeRepo = hiveUrgeRepo;
    exerciseRepo = hiveExerciseRepo;
    achievementRepo = hiveAchievementRepo;
    lifetreeRepo = hiveLifetreeRepo;
  }

  runApp(
    ProviderScope(
      overrides: [
        appStateRepositoryProvider.overrideWithValue(appStateRepo),
        userProfileRepositoryProvider.overrideWithValue(userProfileRepo),
        streakRepositoryProvider.overrideWithValue(streakRepo),
        pledgeRepositoryProvider.overrideWithValue(pledgeRepo),
        relapseRepositoryProvider.overrideWithValue(relapseRepo),
        reasonsRepositoryProvider.overrideWithValue(reasonsRepo),
        notifPrefsRepositoryProvider.overrideWithValue(hiveNotifPrefsRepo),
        journalRepositoryProvider.overrideWithValue(journalRepo),
        urgeRepositoryProvider.overrideWithValue(urgeRepo),
        exerciseRepositoryProvider.overrideWithValue(exerciseRepo),
        achievementRepositoryProvider.overrideWithValue(achievementRepo),
        lifetreeRepositoryProvider.overrideWithValue(lifetreeRepo),
      ],
      child: const QuittrApp(),
    ),
  );
}
