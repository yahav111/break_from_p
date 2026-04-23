import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../phase_c_analysis/dependence_score_engine.dart';
import 'models/recovery_plan.dart';

/// Pure service that builds a personalized [RecoveryPlan] from extended quiz
/// answers and selected goals. Mirrors the shape of [DependenceScoreEngine].
abstract final class RecoveryPlanEngine {
  static RecoveryPlan build({
    required Map<int, int> answers,
    required List<String> goals,
    String? userName,
    DateTime? now,
  }) {
    final effectiveNow = now ?? DateTime.now();

    final freqIdx = answers[1];
    final escalYes = answers[3] == 0;
    final firstExpIdx = answers[4];
    final arousal = answers[5];
    final emotional = answers[6];
    final stress = answers[7];
    final boredom = answers[8];
    final moneyYes = answers[9] == 0;

    final score = DependenceScoreEngine.computeScore(
      frequencyIndex: freqIdx,
      escalation: escalYes,
      firstExposureAgeIndex: firstExpIdx,
      arousalDependency: arousal,
      emotionalCoping: emotional,
      stressTrigger: stress,
      boredomTrigger: boredom,
      spentMoney: moneyYes,
    );

    final severity = _severityFromScore(score);

    final totalDays = _computeTotalDays(
      freqIdx: freqIdx,
      escalYes: escalYes,
      firstExpIdx: firstExpIdx,
      arousal: arousal,
      emotional: emotional,
      stress: stress,
      boredom: boredom,
      moneyYes: moneyYes,
    );

    final totalWeeks = totalDays ~/ 7;
    final quitDate = effectiveNow.add(Duration(days: totalDays));

    final benefits = _buildBenefits(
      goals: goals,
      severity: severity,
      moneyYes: moneyYes,
    );

    final dayPlan = _buildDayPlan(
      userName: userName,
      arousal: arousal,
      emotional: emotional,
      stress: stress,
      boredom: boredom,
    );

    final weeks = _buildWeeks(totalWeeks, severity);

    return RecoveryPlan(
      totalDays: totalDays,
      totalWeeks: totalWeeks,
      estimatedQuitDate: quitDate,
      severity: severity,
      dependenceScore: score,
      benefits: benefits,
      dayPlan: dayPlan,
      weeks: weeks,
    );
  }

  static int _computeTotalDays({
    int? freqIdx,
    required bool escalYes,
    int? firstExpIdx,
    int? arousal,
    int? emotional,
    int? stress,
    int? boredom,
    required bool moneyYes,
  }) {
    int days = 30;

    const freqBonus = [60, 40, 20, 10];
    if (freqIdx != null && freqIdx >= 0 && freqIdx < freqBonus.length) {
      days += freqBonus[freqIdx];
    } else {
      days += 15;
    }

    if (escalYes) days += 15;

    const trigBonus = [8, 4, 1];
    for (final t in [arousal, emotional, stress, boredom]) {
      if (t != null && t >= 0 && t < trigBonus.length) {
        days += trigBonus[t];
      }
    }

    if (moneyYes) days += 10;

    const ageBonus = [10, 5, 2, 0];
    if (firstExpIdx != null && firstExpIdx >= 0 && firstExpIdx < ageBonus.length) {
      days += ageBonus[firstExpIdx];
    } else {
      days += 2;
    }

    days = days.clamp(45, 180);
    // Snap to nearest multiple of 7 within [49, 175] so the plan always lands
    // on a whole week.
    int snapped = (days / 7).round() * 7;
    if (snapped < 49) snapped = 49;
    if (snapped > 175) snapped = 175;
    days = snapped;

    if (freqIdx == 0 && days < 63) days = 63;

    return days;
  }

  static DependenceSeverity _severityFromScore(double score) {
    if (score < 35) return DependenceSeverity.mild;
    if (score < 55) return DependenceSeverity.moderate;
    if (score < 75) return DependenceSeverity.high;
    return DependenceSeverity.severe;
  }

  static const _catalog = <String, RecoveryBenefit>{
    'testosterone': RecoveryBenefit(
      id: 'testosterone',
      label: 'יותר טסטוסטרון',
      emoji: '\u{1F4AA}',
      color: Color(0xFF4CAF50),
      priority: 80,
    ),
    'energy': RecoveryBenefit(
      id: 'energy',
      label: 'יותר אנרגיה',
      emoji: '\u{26A1}',
      color: Color(0xFFFFC107),
      priority: 90,
    ),
    'mental_clarity': RecoveryBenefit(
      id: 'mental_clarity',
      label: 'בהירות מחשבה',
      emoji: '\u{1F9E0}',
      color: Color(0xFF66BB6A),
      priority: 85,
    ),
    'reduced_shame': RecoveryBenefit(
      id: 'reduced_shame',
      label: 'פחות בושה',
      emoji: '\u{1F54A}',
      color: Color(0xFF66BB6A),
      priority: 70,
    ),
    'relationships': RecoveryBenefit(
      id: 'relationships',
      label: 'מערכות יחסים חזקות יותר',
      emoji: '\u{2764}',
      color: Color(0xFFE91E63),
      priority: 85,
    ),
    'intimacy': RecoveryBenefit(
      id: 'intimacy',
      label: 'אינטימיות אמיתית',
      emoji: '\u{1F495}',
      color: Color(0xFFE91E63),
      priority: 70,
    ),
    'confidence': RecoveryBenefit(
      id: 'confidence',
      label: 'ביטחון עצמי משופר',
      emoji: '\u{1F451}',
      color: Color(0xFF9C27B0),
      priority: 85,
    ),
    'self_esteem': RecoveryBenefit(
      id: 'self_esteem',
      label: 'הערכה עצמית גבוהה יותר',
      emoji: '\u{1F31F}',
      color: Color(0xFF9C27B0),
      priority: 70,
    ),
    'self_control': RecoveryBenefit(
      id: 'self_control',
      label: 'שליטה עצמית טובה יותר',
      emoji: '\u{1F6E1}',
      color: Color(0xFF78909C),
      priority: 85,
    ),
    'discipline': RecoveryBenefit(
      id: 'discipline',
      label: 'משמעת חזקה יותר',
      emoji: '\u{1F3CB}',
      color: Color(0xFF78909C),
      priority: 70,
    ),
    'mood': RecoveryBenefit(
      id: 'mood',
      label: 'מצב רוח משופר',
      emoji: '\u{1F60A}',
      color: Color(0xFFFFEE58),
      priority: 85,
    ),
    'reduced_anxiety': RecoveryBenefit(
      id: 'reduced_anxiety',
      label: 'פחות חרדה',
      emoji: '\u{1F9D8}',
      color: Color(0xFFFFEE58),
      priority: 70,
    ),
    'focus': RecoveryBenefit(
      id: 'focus',
      label: 'ריכוז משופר',
      emoji: '\u{1F3AF}',
      color: Color(0xFF2196F3),
      priority: 85,
    ),
    'productivity': RecoveryBenefit(
      id: 'productivity',
      label: 'פרודוקטיביות גבוהה יותר',
      emoji: '\u{1F680}',
      color: Color(0xFF2196F3),
      priority: 70,
    ),
    'prevent_ed': RecoveryBenefit(
      id: 'prevent_ed',
      label: 'מניעת בעיות זקפה',
      emoji: '\u{1F6E1}',
      color: Color(0xFFF44336),
      priority: 95,
    ),
    'financial_savings': RecoveryBenefit(
      id: 'financial_savings',
      label: 'חיסכון כספי',
      emoji: '\u{1F4B0}',
      color: Color(0xFF4CAF50),
      priority: 60,
    ),
    'motivation': RecoveryBenefit(
      id: 'motivation',
      label: 'יותר מוטיבציה',
      emoji: '\u{1F525}',
      color: Color(0xFFFF9800),
      priority: 50,
    ),
  };

  static const _goalToBenefits = <String, List<String>>{
    'energy': ['energy', 'testosterone'],
    'thoughts': ['mental_clarity', 'reduced_shame'],
    'relationships': ['relationships', 'intimacy'],
    'confidence': ['confidence', 'self_esteem'],
    'control': ['self_control', 'discipline'],
    'mood': ['mood', 'reduced_anxiety'],
    'focus': ['focus', 'productivity'],
  };

  static const _defaults = [
    'energy',
    'mood',
    'focus',
    'confidence',
    'self_control',
  ];

  static List<RecoveryBenefit> _buildBenefits({
    required List<String> goals,
    required DependenceSeverity severity,
    required bool moneyYes,
  }) {
    final chosen = <String>{};
    for (final goal in goals) {
      final ids = _goalToBenefits[goal];
      if (ids != null) chosen.addAll(ids);
    }
    if (severity == DependenceSeverity.high ||
        severity == DependenceSeverity.severe) {
      chosen.add('prevent_ed');
    }
    if (moneyYes) chosen.add('financial_savings');

    for (final d in _defaults) {
      if (chosen.length >= 5) break;
      chosen.add(d);
    }
    chosen.add('motivation');

    final list = chosen
        .map((id) => _catalog[id])
        .whereType<RecoveryBenefit>()
        .toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));

    return list.take(7).toList(growable: false);
  }

  // Day 4 "Crush the Symptoms" copy variants keyed by dominant trigger.
  // Keys are internal identifiers (not translated); values are Hebrew copy.
  static const _day4Variants = <String, String>{
    'stress':
        'התמודד עם דחפים שנגרמים מלחץ בעזרת טכניקות שמייצבות את מערכת העצבים.',
    'emotional':
        'זהה את הרגש לפני הדחף — כלים פשוטים לרגעים שבהם רגשות ישנים צפים.',
    'boredom':
        'מלא רגעים ריקים בניצחונות קטנים, כדי שהשעמום יפסיק להחזיר אותך למקום הישן.',
    'arousal':
        'שנה את דפוסי העוררות באמצעות הארקה למציאות — בלי לולאות פנטזיה.',
  };

  static List<DayPlanEntry> _buildDayPlan({
    String? userName,
    int? arousal,
    int? emotional,
    int? stress,
    int? boredom,
  }) {
    String dominantKey = 'stress';
    int bestScore = 99;
    final triggers = <String, int?>{
      'stress': stress,
      'emotional': emotional,
      'boredom': boredom,
      'arousal': arousal,
    };
    triggers.forEach((key, value) {
      if (value != null && value < bestScore) {
        bestScore = value;
        dominantKey = key;
      }
    });

    final day0Title = (userName != null && userName.isNotEmpty)
        ? 'יום 0 — $userName, סדר את הסביבה שלך'
        : 'יום 0 — סדר את הסביבה שלך';

    final day4Desc = _day4Variants[dominantKey] ?? _day4Variants['stress']!;

    return [
      DayPlanEntry(
        dayLabel: day0Title,
        description:
            'נקה את הסביבה הדיגיטלית והחברתית שלך כדי להקל על השינוי.',
        icon: Icons.home_rounded,
      ),
      const DayPlanEntry(
        dayLabel: 'יום 1 — לנצח את הגמילה',
        description:
            'השתמש בכלים מהירים — מנטליים ופיזיים — כדי לעבור גלי דחפים ולחזור לריכוז.',
        icon: Icons.psychology_rounded,
      ),
      const DayPlanEntry(
        dayLabel: 'יום 2 — איפוס המוח מתחיל',
        description:
            'רמות הדופמין מתחילות להתייצב. ייתכן שהדחפים יתגברו זמנית, כחלק מההתאמה.',
        icon: Icons.auto_fix_high_rounded,
      ),
      const DayPlanEntry(
        dayLabel: 'יום 3 — חזק את ה״למה״ שלך',
        description:
            'הפוך את הסיבה שלך לגמילה למקור יומיומי של מוטיבציה ומיקוד.',
        icon: Icons.gps_fixed_rounded,
      ),
      DayPlanEntry(
        dayLabel: 'יום 4 — נצח את התסמינים',
        description: day4Desc,
        icon: Icons.build_rounded,
      ),
      const DayPlanEntry(
        dayLabel: 'יום 5 — הריכוז חוזר',
        description:
            'הערפל מתחיל להתפזר והמוטיבציה שבה לאט. הישאר יציב.',
        icon: Icons.visibility_rounded,
      ),
      const DayPlanEntry(
        dayLabel: 'יום 6 — אתה לא לבד',
        description:
            'התחבר לאחרים באותו מסע. שתף ניצחונות וקבל תמיכה.',
        icon: Icons.groups_rounded,
      ),
      const DayPlanEntry(
        dayLabel: 'יום 7 — חזור לקחת את הזמן שלך',
        description:
            'החלף הרגלים ישנים במטרות אמיתיות ובפעולה משמעותית.',
        icon: Icons.schedule_rounded,
      ),
    ];
  }

  static List<RecoveryWeekPoint> _buildWeeks(
    int totalWeeks,
    DependenceSeverity severity,
  ) {
    final n = totalWeeks.clamp(2, 12);
    final quittrPow = switch (severity) {
      DependenceSeverity.severe => 0.50,
      DependenceSeverity.high => 0.55,
      DependenceSeverity.moderate => 0.60,
      DependenceSeverity.mild => 0.65,
    };
    final amplBump = switch (severity) {
      DependenceSeverity.severe => 0.08,
      DependenceSeverity.high => 0.05,
      DependenceSeverity.moderate => 0.02,
      DependenceSeverity.mild => 0.0,
    };

    return List.generate(n, (w) {
      final t = n == 1 ? 0.0 : w / (n - 1);
      final quittr = math.pow(t, quittrPow).toDouble();
      final conventional = 0.30 + 0.20 * t;
      final rel = (0.25 + (0.15 + amplBump) * math.sin(w * 1.8))
          .clamp(0.05, 0.95)
          .toDouble();
      return RecoveryWeekPoint(
        weekIndex: w,
        quittr: quittr,
        conventional: conventional,
        relapses: rel,
      );
    });
  }
}
