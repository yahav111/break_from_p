import 'package:flutter_test/flutter_test.dart';
import 'package:quitter/core/models/streak_data.dart';

void main() {
  group('StreakData', () {
    test('currentStreakDays computes days since quitDate', () {
      final tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
      final data = StreakData(quitDate: tenDaysAgo);
      expect(data.currentStreakDays, 10);
    });

    test('default values', () {
      final data = StreakData(quitDate: DateTime.now());
      expect(data.longestStreakDays, 0);
      expect(data.resetHistory, isEmpty);
    });

    test('copyWith updates longestStreakDays', () {
      final data = StreakData(quitDate: DateTime.now());
      final updated = data.copyWith(longestStreakDays: 42);
      expect(updated.longestStreakDays, 42);
    });

    test('copyWith updates resetHistory', () {
      final data = StreakData(quitDate: DateTime.now());
      final resetTime = DateTime.now();
      final updated = data.copyWith(resetHistory: [resetTime]);
      expect(updated.resetHistory, hasLength(1));
    });
  });
}
