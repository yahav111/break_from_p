import 'package:flutter_test/flutter_test.dart';
import 'package:quitter/features/onboarding/phases/phase_h_paywall/models/recovery_plan.dart';
import 'package:quitter/features/onboarding/phases/phase_h_paywall/recovery_plan_engine.dart';

void main() {
  group('RecoveryPlanEngine.totalDays', () {
    test('empty answers → 49 days (snap of 47 to nearest 7)', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {},
        goals: const [],
      );
      expect(plan.totalDays, 49);
    });

    test('heaviest answers everywhere → 154 days', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {
          1: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0,
        },
        goals: const [],
      );
      expect(plan.totalDays, 154);
    });

    test('always a multiple of 7', () {
      final samples = <Map<int, int>>[
        const {},
        const {1: 0},
        const {1: 3, 4: 3},
        const {1: 1, 3: 0, 4: 1, 5: 1, 6: 2, 7: 0, 8: 2, 9: 1},
        const {1: 2, 3: 1, 4: 2, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0},
        const {1: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0},
      ];
      for (final answers in samples) {
        final plan = RecoveryPlanEngine.build(
          answers: answers,
          goals: const [],
        );
        expect(
          plan.totalDays % 7,
          0,
          reason: 'answers=$answers → totalDays=${plan.totalDays}',
        );
        expect(plan.totalDays, inInclusiveRange(45, 180));
      }
    });

    test('daily-frequency user never drops below 63 days', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {1: 0},
        goals: const [],
      );
      expect(plan.totalDays, greaterThanOrEqualTo(63));
    });

    test('totalWeeks equals totalDays ~/ 7', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {1: 1, 3: 0},
        goals: const [],
      );
      expect(plan.totalWeeks, plan.totalDays ~/ 7);
    });
  });

  group('RecoveryPlanEngine.estimatedQuitDate', () {
    test('equals injected now + totalDays', () {
      final now = DateTime(2026, 1, 1);
      final plan = RecoveryPlanEngine.build(
        answers: const {},
        goals: const [],
        now: now,
      );
      expect(
        plan.estimatedQuitDate,
        now.add(Duration(days: plan.totalDays)),
      );
    });
  });

  group('RecoveryPlanEngine.severity', () {
    test('empty answers → mild', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {},
        goals: const [],
      );
      expect(plan.severity, DependenceSeverity.mild);
    });

    test('moderate bucket', () {
      // Raw ~39 → normalized ~40.6 → moderate
      final plan = RecoveryPlanEngine.build(
        answers: const {
          1: 2, 3: 1, 4: 2, 5: 1, 6: 1, 7: 1, 8: 1, 9: 1,
        },
        goals: const [],
      );
      expect(plan.severity, DependenceSeverity.moderate);
    });

    test('high bucket', () {
      // Raw ~71 → normalized ~73.9 → high
      final plan = RecoveryPlanEngine.build(
        answers: const {
          1: 1, 3: 0, 4: 1, 5: 0, 6: 0, 7: 1, 8: 1, 9: 1,
        },
        goals: const [],
      );
      expect(plan.severity, DependenceSeverity.high);
    });

    test('severe bucket', () {
      // All-heaviest → normalized 100 → severe
      final plan = RecoveryPlanEngine.build(
        answers: const {
          1: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0,
        },
        goals: const [],
      );
      expect(plan.severity, DependenceSeverity.severe);
    });
  });

  group('RecoveryPlanEngine.benefits', () {
    test('length always in [5, 7]', () {
      final cases = <({Map<int, int> answers, List<String> goals})>[
        (answers: const {}, goals: const []),
        (answers: const {9: 0}, goals: const ['energy']),
        (
          answers: const {1: 0, 3: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0},
          goals: const ['energy', 'focus', 'confidence'],
        ),
        (
          answers: const {},
          goals: const [
            'energy', 'thoughts', 'relationships', 'confidence',
            'control', 'mood', 'focus',
          ],
        ),
      ];
      for (final c in cases) {
        final plan = RecoveryPlanEngine.build(
          answers: c.answers,
          goals: c.goals,
        );
        expect(
          plan.benefits.length,
          inInclusiveRange(5, 7),
          reason: 'case=${c.answers} goals=${c.goals}',
        );
      }
    });

    test('goals=["energy"] pulls in energy and testosterone benefits', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {},
        goals: const ['energy'],
      );
      final ids = plan.benefits.map((b) => b.id).toSet();
      expect(ids.contains('energy'), isTrue);
      expect(ids.contains('testosterone'), isTrue);
    });

    test('severity high auto-adds prevent_ed', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {
          1: 1, 3: 0, 4: 1, 5: 0, 6: 0, 7: 1, 8: 1, 9: 1,
        },
        goals: const [],
      );
      expect(plan.severity, DependenceSeverity.high);
      expect(
        plan.benefits.map((b) => b.id).contains('prevent_ed'),
        isTrue,
      );
    });

    test('spentMoney=Yes auto-adds financial_savings', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {9: 0},
        goals: const [],
      );
      expect(
        plan.benefits.map((b) => b.id).contains('financial_savings'),
        isTrue,
      );
    });

    test('mild user with no goals and no money → no prevent_ed, no financial_savings',
        () {
      final plan = RecoveryPlanEngine.build(
        answers: const {1: 3, 9: 1},
        goals: const [],
      );
      expect(plan.severity, DependenceSeverity.mild);
      final ids = plan.benefits.map((b) => b.id).toSet();
      expect(ids.contains('prevent_ed'), isFalse);
      expect(ids.contains('financial_savings'), isFalse);
    });

    test('benefits sorted by priority descending', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {
          1: 0, 3: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0,
        },
        goals: const ['energy', 'focus'],
      );
      for (var i = 1; i < plan.benefits.length; i++) {
        expect(
          plan.benefits[i - 1].priority,
          greaterThanOrEqualTo(plan.benefits[i].priority),
        );
      }
    });
  });

  group('RecoveryPlanEngine.dayPlan', () {
    test('always has 8 entries (Day 0..Day 7)', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {},
        goals: const [],
      );
      expect(plan.dayPlan.length, 8);
    });

    test('Day 0 label includes userName when provided', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {},
        goals: const [],
        userName: 'Alex',
      );
      expect(plan.dayPlan.first.dayLabel, contains('Alex'));
    });

    test('Day 0 label has no name suffix when userName missing', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {},
        goals: const [],
      );
      expect(plan.dayPlan.first.dayLabel, 'יום 0 — סדר את הסביבה שלך');
    });

    test('Day 4 description adapts to dominant trigger (stress)', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {7: 0}, // stress=Frequently (dominant)
        goals: const [],
      );
      expect(plan.dayPlan[4].description, contains('לחץ'));
    });

    test('Day 4 description adapts to dominant trigger (boredom)', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {8: 0}, // boredom dominant
        goals: const [],
      );
      expect(plan.dayPlan[4].description, contains('שעמום'));
    });
  });

  group('RecoveryPlanEngine.weeks', () {
    test('length equals min(totalWeeks, 12) with a floor of 2', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {},
        goals: const [],
      );
      final expected = plan.totalWeeks.clamp(2, 12);
      expect(plan.weeks.length, expected);
    });

    test('all progress values within [0, 1]', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {
          1: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0,
        },
        goals: const [],
      );
      for (final w in plan.weeks) {
        expect(w.quittr, inInclusiveRange(0.0, 1.0));
        expect(w.conventional, inInclusiveRange(0.0, 1.0));
        expect(w.relapses, inInclusiveRange(0.0, 1.0));
      }
    });

    test('quittr trajectory is monotonically non-decreasing', () {
      final plan = RecoveryPlanEngine.build(
        answers: const {1: 1},
        goals: const [],
      );
      for (var i = 1; i < plan.weeks.length; i++) {
        expect(
          plan.weeks[i].quittr,
          greaterThanOrEqualTo(plan.weeks[i - 1].quittr),
        );
      }
    });
  });
}
