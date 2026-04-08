abstract final class Routes {
  static const welcome = '/welcome';
  static const quiz = '/quiz';
  static const onboarding = '/onboarding';
  static const onboardingFlow = '/onboarding-flow';
  static const paywall = '/paywall';
  static const auth = '/auth';
  static const home = '/';
  static const library = '/library';
  static const journal = '/journal';
  static const profile = '/profile';
  static const settings = '/settings';
  static const settingsTab = '/settings-tab';
  static const statisticsTab = '/statistics-tab';
  static const panicMode = '/panic';

  // Journal sub-routes.
  static const journalEntry = '/journal/entry';
  static const journalHistory = '/journal/history';

  // Library sub-routes.
  static const meditate = '/library/meditate';
  static const breathingExercise = '/library/meditate/breathing';
  static const urgeSurfing = '/library/meditate/urge-surfing';
  static const grounding = '/library/meditate/grounding';
  static const soundscapes = '/library/soundscapes';
  static const moodHistory = '/library/mood';

  // Urge tracker (full-screen, outside shell).
  static const urgeTracker = '/urge';

  // Phase 4: Gamification routes.
  static const badges = '/profile/badges';
  static const statistics = '/profile/statistics';
  static const lifetree = '/library/lifetree';
  static const bodyScan = '/library/meditate/body-scan';
}
