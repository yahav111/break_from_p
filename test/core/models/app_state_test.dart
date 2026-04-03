import 'package:flutter_test/flutter_test.dart';
import 'package:quitter/core/models/app_state.dart';

void main() {
  group('AppState', () {
    test('default values', () {
      const state = AppState();
      expect(state.onboardingCompleted, false);
      expect(state.firstLaunch, true);
    });

    test('copyWith updates onboardingCompleted', () {
      const state = AppState();
      final updated = state.copyWith(onboardingCompleted: true);
      expect(updated.onboardingCompleted, true);
      expect(updated.firstLaunch, true); // unchanged
    });

    test('copyWith updates firstLaunch', () {
      const state = AppState();
      final updated = state.copyWith(firstLaunch: false);
      expect(updated.firstLaunch, false);
      expect(updated.onboardingCompleted, false); // unchanged
    });
  });
}
