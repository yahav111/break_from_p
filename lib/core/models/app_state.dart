/// Application-level state stored in SharedPreferences.
class AppState {
  const AppState({
    this.onboardingCompleted = false,
    this.firstLaunch = true,
    this.lastCelebratedMilestone = 0,
    this.lastShownCharacterStage = '',
  });

  final bool onboardingCompleted;
  final bool firstLaunch;

  /// The highest milestone (in days) for which a celebration was shown.
  final int lastCelebratedMilestone;

  /// The character stage name last shown to the user (for evolution animation).
  final String lastShownCharacterStage;

  AppState copyWith({
    bool? onboardingCompleted,
    bool? firstLaunch,
    int? lastCelebratedMilestone,
    String? lastShownCharacterStage,
  }) {
    return AppState(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      firstLaunch: firstLaunch ?? this.firstLaunch,
      lastCelebratedMilestone:
          lastCelebratedMilestone ?? this.lastCelebratedMilestone,
      lastShownCharacterStage:
          lastShownCharacterStage ?? this.lastShownCharacterStage,
    );
  }
}
