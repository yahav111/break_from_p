import 'package:flutter_test/flutter_test.dart';
import 'package:quitter/core/models/relapse_data.dart';
import 'package:quitter/core/models/relapse_entry.dart';

void main() {
  group('RelapseData', () {
    test('default values', () {
      final data = RelapseData();
      expect(data.totalRelapses, 0);
      expect(data.relapseHistory, isEmpty);
    });

    test('copyWith updates totalRelapses', () {
      final data = RelapseData();
      final updated = data.copyWith(totalRelapses: 3);
      expect(updated.totalRelapses, 3);
      expect(updated.relapseHistory, isEmpty);
    });

    test('copyWith updates relapseHistory', () {
      final entry = RelapseEntry(
        date: DateTime.now(),
        reason: 'Stress',
        streakDaysLost: 7,
      );
      final data = RelapseData();
      final updated = data.copyWith(relapseHistory: [entry]);
      expect(updated.relapseHistory, hasLength(1));
      expect(updated.relapseHistory.first.reason, 'Stress');
      expect(updated.relapseHistory.first.streakDaysLost, 7);
    });
  });

  group('RelapseEntry', () {
    test('stores all fields', () {
      final now = DateTime.now();
      final entry = RelapseEntry(
        date: now,
        reason: 'Boredom',
        streakDaysLost: 14,
      );
      expect(entry.date, now);
      expect(entry.reason, 'Boredom');
      expect(entry.streakDaysLost, 14);
    });

    test('reason is nullable', () {
      final entry = RelapseEntry(
        date: DateTime.now(),
        streakDaysLost: 0,
      );
      expect(entry.reason, isNull);
    });
  });
}
