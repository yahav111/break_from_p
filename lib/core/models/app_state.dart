/// Application-level state stored in SharedPreferences.
class AppState {
  const AppState({
    this.onboardingCompleted = false,
    this.firstLaunch = true,
    this.lastCelebratedMilestone = 0,
  });

  final bool onboardingCompleted;
  final bool firstLaunch;

  /// The highest milestone (in days) for which a celebration was shown.
  final int lastCelebratedMilestone;

  AppState copyWith({
    bool? onboardingCompleted,
    bool? firstLaunch,
    int? lastCelebratedMilestone,
  }) {
    return AppState(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      firstLaunch: firstLaunch ?? this.firstLaunch,
      lastCelebratedMilestone:
          lastCelebratedMilestone ?? this.lastCelebratedMilestone,
    );
  }
}
