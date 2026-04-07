import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/app_state_provider.dart';
import 'data/sync/sync_engine.dart';
import 'design_system/design_system.dart';
import 'infrastructure/auth/auth_provider.dart';
import 'infrastructure/auth/auth_state.dart';
import 'routing/app_router.dart';

class QuittrApp extends ConsumerStatefulWidget {
  const QuittrApp({super.key});

  @override
  ConsumerState<QuittrApp> createState() => _QuittrAppState();
}

class _QuittrAppState extends ConsumerState<QuittrApp> {
  bool _authTriggered = false;

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final appState = ref.watch(appStateNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    // After onboarding completes, trigger anonymous sign-in once.
    if (appState.onboardingCompleted &&
        authState.status == AuthStatus.unauthenticated &&
        !authState.isLoading &&
        !_authTriggered) {
      _authTriggered = true;
      Future.microtask(() async {
        await ref.read(authNotifierProvider.notifier).signInAnonymously();
        // After sign-in, migrate local data to cloud.
        await ref.read(syncEngineProvider.notifier).migrateLocalToCloud();
      });
    }

    return MaterialApp.router(
      routerConfig: router,
      title: 'QUITTR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
