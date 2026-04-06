import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/app_state.dart';

class AppStateRepository {
  AppStateRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _keyOnboardingCompleted = 'onboarding_completed';
  static const _keyFirstLaunch = 'first_launch';
  static const _keyLastCelebratedMilestone = 'last_celebrated_milestone';
  static const _keyLastShownCharacterStage = 'last_shown_character_stage';

  AppState load() {
    return AppState(
      onboardingCompleted: _prefs.getBool(_keyOnboardingCompleted) ?? false,
      firstLaunch: _prefs.getBool(_keyFirstLaunch) ?? true,
      lastCelebratedMilestone:
          _prefs.getInt(_keyLastCelebratedMilestone) ?? 0,
      lastShownCharacterStage:
          _prefs.getString(_keyLastShownCharacterStage) ?? '',
    );
  }

  Future<void> save(AppState state) async {
    await Future.wait([
      _prefs.setBool(_keyOnboardingCompleted, state.onboardingCompleted),
      _prefs.setBool(_keyFirstLaunch, state.firstLaunch),
      _prefs.setInt(
          _keyLastCelebratedMilestone, state.lastCelebratedMilestone),
      _prefs.setString(
          _keyLastShownCharacterStage, state.lastShownCharacterStage),
    ]);
  }

  Future<void> completeOnboarding() async {
    await Future.wait([
      _prefs.setBool(_keyOnboardingCompleted, true),
      _prefs.setBool(_keyFirstLaunch, false),
    ]);
  }
}
