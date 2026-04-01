import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/app_state_provider.dart';
import '../features/home/home_screen.dart';
import '../features/journal/journal_screen.dart';
import '../features/library/library_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/panic_mode/panic_mode_screen.dart';
import '../features/paywall/paywall_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/quiz/quiz_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/main_shell.dart';
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
        Routes.paywall,
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
        pageBuilder: (context, state) => _fadeTransitionPage(
          state,
          const WelcomeScreen(),
        ),
      ),
      GoRoute(
        path: Routes.quiz,
        pageBuilder: (context, state) => _fadeTransitionPage(
          state,
          const QuizScreen(),
        ),
      ),
      GoRoute(
        path: Routes.onboarding,
        pageBuilder: (context, state) => _fadeTransitionPage(
          state,
          const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: Routes.paywall,
        pageBuilder: (context, state) => _fadeTransitionPage(
          state,
          const PaywallScreen(),
        ),
      ),

      // Full-screen routes outside the shell (no bottom nav).
      GoRoute(
        path: Routes.settings,
        pageBuilder: (context, state) => _fadeTransitionPage(
          state,
          const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: Routes.panicMode,
        pageBuilder: (context, state) => _fadeTransitionPage(
          state,
          const PanicModeScreen(),
        ),
      ),

      // Main app — bottom nav shell.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
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
                path: Routes.library,
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
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
                path: Routes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

CustomTransitionPage<void> _fadeTransitionPage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
