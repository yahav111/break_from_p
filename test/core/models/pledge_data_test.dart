import 'package:flutter_test/flutter_test.dart';
import 'package:quitter/core/models/pledge_data.dart';

void main() {
  group('PledgeData', () {
    test('default values', () {
      final data = PledgeData();
      expect(data.pledgeDates, isEmpty);
      expect(data.currentPledgeStreak, 0);
      expect(data.longestPledgeStreak, 0);
      expect(data.lastPledgeDate, isNull);
    });

    test('copyWith updates fields', () {
      final now = DateTime.now();
      final data = PledgeData();
      final updated = data.copyWith(
        pledgeDates: [now],
        currentPledgeStreak: 1,
        longestPledgeStreak: 1,
        lastPledgeDate: now,
      );
      expect(updated.pledgeDates, [now]);
      expect(updated.currentPledgeStreak, 1);
      expect(updated.longestPledgeStreak, 1);
      expect(updated.lastPledgeDate, now);
    });

    test('copyWith preserves unset fields', () {
      final now = DateTime.now();
      final data = PledgeData(
        pledgeDates: [now],
        currentPledgeStreak: 3,
        longestPledgeStreak: 5,
        lastPledgeDate: now,
      );
      final updated = data.copyWith(currentPledgeStreak: 4);
      expect(updated.pledgeDates, [now]);
      expect(updated.currentPledgeStreak, 4);
      expect(updated.longestPledgeStreak, 5);
      expect(updated.lastPledgeDate, now);
    });
  });
}
