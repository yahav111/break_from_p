import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
import 'data/repositories/achievement_repository.dart';
import 'data/repositories/app_state_repository.dart';
import 'data/repositories/exercise_repository.dart';
import 'data/repositories/journal_repository.dart';
import 'data/repositories/lifetree_repository.dart';
import 'data/repositories/notification_preferences_repository.dart';
import 'data/repositories/pledge_repository.dart';
import 'data/repositories/reasons_repository.dart';
import 'data/repositories/relapse_repository.dart';
import 'data/repositories/streak_repository.dart';
import 'data/repositories/urge_repository.dart';
import 'data/repositories/user_profile_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

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

  // Create repositories.
  final appStateRepo = AppStateRepository(prefs);
  final userProfileRepo = UserProfileRepository(userBox);
  final streakRepo = StreakRepository(streakBox);
  final pledgeRepo = PledgeRepository(pledgeBox);
  final relapseRepo = RelapseRepository(relapseBox);
  final reasonsRepo = ReasonsRepository(reasonsBox);
  final notifPrefsRepo = NotificationPreferencesRepository(notifPrefsBox);
  final journalRepo = JournalRepository(journalBox);
  final urgeRepo = UrgeRepository(urgeBox);
  final exerciseRepo = ExerciseRepository(exerciseBox);
  final achievementRepo = AchievementRepository(achievementBox);
  final lifetreeRepo = LifetreeRepository(lifetreeBox);

  runApp(
    ProviderScope(
      overrides: [
        appStateRepositoryProvider.overrideWithValue(appStateRepo),
        userProfileRepositoryProvider.overrideWithValue(userProfileRepo),
        streakRepositoryProvider.overrideWithValue(streakRepo),
        pledgeRepositoryProvider.overrideWithValue(pledgeRepo),
        relapseRepositoryProvider.overrideWithValue(relapseRepo),
        reasonsRepositoryProvider.overrideWithValue(reasonsRepo),
        notifPrefsRepositoryProvider.overrideWithValue(notifPrefsRepo),
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
