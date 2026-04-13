import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/models/breathing_params.dart';
import '../core/providers/app_state_provider.dart';
import '../features/achievements/badge_collection_screen.dart';
import '../features/exercises/body_scan_screen.dart';
import '../features/exercises/breathing_exercise_screen.dart';
import '../features/exercises/grounding_screen.dart';
import '../features/exercises/meditate_screen.dart';
import '../features/exercises/urge_surfing_screen.dart';
import '../features/lifetree/lifetree_screen.dart';
import '../features/home/home_screen.dart';
import '../features/journal/journal_entry_screen.dart';
import '../features/journal/journal_history_screen.dart';
import '../features/journal/journal_screen.dart';
import '../features/library/library_screen.dart';
import '../features/library/widgets/mood_history_screen.dart';
import '../features/onboarding/onboarding_flow_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/paywall/paywall_screen.dart';
import '../features/quiz/quiz_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/main_shell.dart';
import '../features/soundscapes/soundscapes_screen.dart';
import '../features/course/course_screen.dart';
import '../features/statistics/statistics_screen.dart';
import '../features/urge_tracker/urge_tracker_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/welcome/welcome_screen.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final appState = ref.watch(appStateNotifierProvider);

  return GoRouter(
    initialLocation: Routes.home,
    redirect: (context, state) {
      final onboardingDone = appState.onboardingCompleted;
      final currentPath = state.uri.path;

      const onboardingPaths = [
        Routes.welcome,
        Routes.quiz,
        Routes.onboarding,
        Routes.onboardingFlow,
        Routes.paywall,
        Routes.auth,
      ];

      final isOnOnboardingRoute = onboardingPaths.contains(currentPath);

      if (!onboardingDone && !isOnOnboardingRoute) {
        return Routes.welcome;
      }

      if (onboardingDone && isOnOnboardingRoute) {
        return Routes.home;
      }

      return null;
    },
    routes: [
      // Onboarding flow — no bottom nav shell.
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.quiz,
        builder: (context, state) => const QuizScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.paywall,
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: Routes.onboardingFlow,
        builder: (context, state) => const OnboardingFlowScreen(),
      ),
      GoRoute(
        path: Routes.auth,
        builder: (context, state) {
          final mode = state.uri.queryParameters['mode'] ?? 'signUp';
          return AuthScreen(
            initialMode:
                mode == 'signIn' ? AuthMode.signIn : AuthMode.signUp,
          );
        },
      ),

      // Full-screen routes outside the shell (no bottom nav).
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.journalEntry,
        builder: (context, state) => const JournalEntryScreen(),
      ),
      GoRoute(
        path: Routes.journalHistory,
        builder: (context, state) => const JournalHistoryScreen(),
      ),

      // Library sub-routes (full-screen, outside shell).
      GoRoute(
        path: Routes.soundscapes,
        builder: (context, state) => const SoundscapesScreen(),
      ),
      GoRoute(
        path: Routes.moodHistory,
        builder: (context, state) => const MoodHistoryScreen(),
      ),
      GoRoute(
        path: Routes.meditate,
        builder: (context, state) => const MeditateScreen(),
      ),
      GoRoute(
        path: Routes.breathingExercise,
        builder: (context, state) {
          final params = state.extra;
          return BreathingExerciseScreen(
            params: params is BreathingParams ? params : null,
          );
        },
      ),
      GoRoute(
        path: Routes.urgeSurfing,
        builder: (context, state) => const UrgeSurfingScreen(),
      ),
      GoRoute(
        path: Routes.grounding,
        builder: (context, state) => const GroundingScreen(),
      ),
      GoRoute(
        path: Routes.urgeTracker,
        builder: (context, state) => const UrgeTrackerScreen(),
      ),
      GoRoute(
        path: Routes.statistics,
        builder: (context, state) => const StatisticsScreen(),
      ),
      GoRoute(
        path: Routes.badges,
        builder: (context, state) => const BadgeCollectionScreen(),
      ),
      GoRoute(
        path: Routes.lifetree,
        builder: (context, state) => const LifetreeScreen(),
      ),
      GoRoute(
        path: Routes.bodyScan,
        builder: (context, state) => const BodyScanScreen(),
      ),

      // Main app — 5-tab bottom nav shell.
      // Order: Journal (0), Tools (1), Home (2, center), Statistics (3), Settings (4)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.journal,
                builder: (context, state) => const JournalScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.library,
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.courseTab,
                builder: (context, state) => const CourseScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settingsTab,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

