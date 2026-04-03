import 'package:flutter_test/flutter_test.dart';
import 'package:quitter/core/services/streak_engine.dart';

void main() {
  group('StreakEngine', () {
    group('daysSince', () {
      test('returns 0 for today', () {
        final today = DateTime.now();
        expect(StreakEngine.daysSince(today), 0);
      });

      test('returns correct days for past date', () {
        final tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
        expect(StreakEngine.daysSince(tenDaysAgo), 10);
      });

      test('returns correct days for far past date', () {
        final ninetyDaysAgo =
            DateTime.now().subtract(const Duration(days: 90));
        expect(StreakEngine.daysSince(ninetyDaysAgo), 90);
      });
    });

    group('longestStreak', () {
      test('returns current if longer', () {
        expect(StreakEngine.longestStreak(30, 20), 30);
      });

      test('returns previous if longer', () {
        expect(StreakEngine.longestStreak(5, 20), 20);
      });

      test('returns either when equal', () {
        expect(StreakEngine.longestStreak(15, 15), 15);
      });
    });

    group('brainRewireProgress', () {
      test('returns 0.0 for day 0', () {
        expect(StreakEngine.brainRewireProgress(0), 0.0);
      });

      test('returns 0.5 for day 45', () {
        expect(StreakEngine.brainRewireProgress(45), 0.5);
      });

      test('returns 1.0 for day 90', () {
        expect(StreakEngine.brainRewireProgress(90), 1.0);
      });

      test('clamps to 1.0 for days beyond 90', () {
        expect(StreakEngine.brainRewireProgress(120), 1.0);
      });
    });

    group('formatDuration', () {
      test('formats zero duration', () {
        expect(StreakEngine.formatDuration(Duration.zero), '0d 0h 0m 0s');
      });

      test('formats days hours minutes seconds', () {
        const d = Duration(days: 3, hours: 5, minutes: 22, seconds: 45);
        expect(StreakEngine.formatDuration(d), '3d 5h 22m 45s');
      });

      test('formats large durations', () {
        const d = Duration(days: 90, hours: 23, minutes: 59, seconds: 59);
        expect(StreakEngine.formatDuration(d), '90d 23h 59m 59s');
      });
    });

    group('checkMilestone', () {
      test('returns null for non-milestone day', () {
        expect(StreakEngine.checkMilestone(5), isNull);
        expect(StreakEngine.checkMilestone(15), isNull);
        expect(StreakEngine.checkMilestone(0), isNull);
      });

      test('returns MilestoneInfo for milestone days', () {
        for (final days in [7, 14, 30, 60, 90]) {
          final info = StreakEngine.checkMilestone(days);
          expect(info, isNotNull, reason: 'milestone at $days should exist');
          expect(info!.days, days);
          expect(info.title, isNotEmpty);
          expect(info.scienceMessage, isNotEmpty);
        }
      });
    });

    group('highestMilestoneReached', () {
      test('returns null for day 0', () {
        expect(StreakEngine.highestMilestoneReached(0), isNull);
      });

      test('returns null for day 6', () {
        expect(StreakEngine.highestMilestoneReached(6), isNull);
      });

      test('returns 7 for day 7', () {
        expect(StreakEngine.highestMilestoneReached(7), 7);
      });

      test('returns 14 for day 20', () {
        expect(StreakEngine.highestMilestoneReached(20), 14);
      });

      test('returns 90 for day 100', () {
        expect(StreakEngine.highestMilestoneReached(100), 90);
      });
    });

    group('milestoneMessage', () {
      test('returns message for valid milestones', () {
        expect(StreakEngine.milestoneMessage(7), isNotEmpty);
        expect(StreakEngine.milestoneMessage(90), isNotEmpty);
      });

      test('returns empty for non-milestone', () {
        expect(StreakEngine.milestoneMessage(5), isEmpty);
      });
    });
  });
}
