import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/app_state.dart';

class AppStateRepository {
  AppStateRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _keyOnboardingCompleted = 'onboarding_completed';
  static const _keyFirstLaunch = 'first_launch';
  static const _keyLastCelebratedMilestone = 'last_celebrated_milestone';

  AppState load() {
    return AppState(
      onboardingCompleted: _prefs.getBool(_keyOnboardingCompleted) ?? false,
      firstLaunch: _prefs.getBool(_keyFirstLaunch) ?? true,
      lastCelebratedMilestone:
          _prefs.getInt(_keyLastCelebratedMilestone) ?? 0,
    );
  }

  Future<void> save(AppState state) async {
    await Future.wait([
      _prefs.setBool(_keyOnboardingCompleted, state.onboardingCompleted),
      _prefs.setBool(_keyFirstLaunch, state.firstLaunch),
      _prefs.setInt(
          _keyLastCelebratedMilestone, state.lastCelebratedMilestone),
    ]);
  }

  Future<void> completeOnboarding() async {
    await Future.wait([
      _prefs.setBool(_keyOnboardingCompleted, true),
      _prefs.setBool(_keyFirstLaunch, false),
    ]);
  }
}
