import 'dart:ui';

import '../models/breathing_params.dart';

/// Category for Lifetree branches.
enum LifetreeCategory { breathing, journaling, meditation, soundscapes }

/// Unlock condition for a Lifetree node.
class LifetreeUnlockCondition {
  const LifetreeUnlockCondition({
    this.minStreakDays = 0,
    this.minExercises = 0,
    this.minJournalEntries = 0,
  });

  final int minStreakDays;
  final int minExercises;
  final int minJournalEntries;

  String describe() {
    final parts = <String>[];
    if (minStreakDays > 0) parts.add('רצף של $minStreakDays ימים');
    if (minExercises > 0) parts.add('$minExercises תרגילים שהושלמו');
    if (minJournalEntries > 0) parts.add('$minJournalEntries רשומות יומן');
    return parts.join(' + ');
  }
}

/// A node in the Lifetree.
class LifetreeNode {
  const LifetreeNode({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.unlockCondition,
    required this.position,
    this.breathingParams,
    this.isComingSoon = false,
  });

  final String id;
  final String title;
  final String description;
  final LifetreeCategory category;
  final LifetreeUnlockCondition unlockCondition;

  /// Normalized position (0.0–1.0) for tree layout.
  final Offset position;

  /// Breathing params if this is a breathing node.
  final BreathingParams? breathingParams;

  /// True for placeholder nodes (e.g., soundscapes without audio).
  final bool isComingSoon;
}

/// Pure logic for Lifetree node definitions and unlock conditions.
abstract final class LifetreeEngine {
  static const nodes = <LifetreeNode>[
    // ── Breathing branch (top-left) ──
    LifetreeNode(
      id: 'breathing_478',
      title: 'נשימה מרגיעה 4-7-8',
      description:
          'תבנית מרגיעה: 4 שניות שאיפה, 7 שניות עצירה, 8 שניות נשיפה. '
          'מפעילה את מערכת העצבים הפָּרָסִימְפָּתֶטית.',
      category: LifetreeCategory.breathing,
      unlockCondition: LifetreeUnlockCondition(minStreakDays: 3),
      position: Offset(0.2, 0.2),
      breathingParams: BreathingParams(
        inhale: 4,
        hold: 7,
        exhale: 8,
        cycles: 4,
        label: '4-7-8 מרגיעה',
      ),
    ),
    LifetreeNode(
      id: 'breathing_55',
      title: 'נשימה מאוזנת 5-5',
      description:
          'נשימה מאוזנת: 5 שניות שאיפה, 5 שניות נשיפה. '
          'יוצרת שיווי משקל בין המערכת הסימפתטית לפרה-סימפתטית.',
      category: LifetreeCategory.breathing,
      unlockCondition: LifetreeUnlockCondition(minStreakDays: 7),
      position: Offset(0.15, 0.35),
      breathingParams: BreathingParams(
        inhale: 5,
        hold: 0,
        exhale: 5,
        cycles: 6,
        label: '5-5 מאוזנת',
      ),
    ),
    LifetreeNode(
      id: 'breathing_627',
      title: 'נשימה ממריצה 6-2-7',
      description:
          'תבנית ממריצה: 6 שניות שאיפה, 2 שניות עצירה, 7 שניות נשיפה. '
          'מגבירה ערנות תוך שמירה על רוגע.',
      category: LifetreeCategory.breathing,
      unlockCondition: LifetreeUnlockCondition(minStreakDays: 14),
      position: Offset(0.25, 0.48),
      breathingParams: BreathingParams(
        inhale: 6,
        hold: 2,
        exhale: 7,
        cycles: 5,
        label: '6-2-7 ממריצה',
      ),
    ),

    // ── Journaling branch (top-right) ──
    LifetreeNode(
      id: 'journal_deep',
      title: 'הרהור עמוק',
      description: 'פתיחת פרומפטים התבוננותיים שעוזרים לך '
          'להבין את הדפוסים והטריגרים שלך.',
      category: LifetreeCategory.journaling,
      unlockCondition: LifetreeUnlockCondition(minStreakDays: 5),
      position: Offset(0.8, 0.2),
    ),
    LifetreeNode(
      id: 'journal_gratitude',
      title: 'תרגול הכרת תודה',
      description: 'פתיחת פרומפטים ממוקדי הכרת תודה שמסיטים '
          'את החשיבה שלך לעבר הערכה ותקווה.',
      category: LifetreeCategory.journaling,
      unlockCondition: LifetreeUnlockCondition(minJournalEntries: 10),
      position: Offset(0.85, 0.35),
    ),
    LifetreeNode(
      id: 'journal_future',
      title: 'מכתבים לעצמך העתידי',
      description: 'פתיחת פרומפטים לכתיבה לעצמך העתידי '
          'ודמיון האדם שאתה הופך להיות.',
      category: LifetreeCategory.journaling,
      unlockCondition: LifetreeUnlockCondition(minStreakDays: 14),
      position: Offset(0.75, 0.48),
    ),

    // ── Meditation branch (bottom-left) ──
    LifetreeNode(
      id: 'meditation_body_scan',
      title: 'סריקת גוף',
      description: 'מדיטציית סריקת גוף מודרכת שבונה '
          'מודעות לתחושות גופניות ומשחררת מתח.',
      category: LifetreeCategory.meditation,
      unlockCondition: LifetreeUnlockCondition(minExercises: 5),
      position: Offset(0.3, 0.7),
    ),

    // ── Soundscapes branch (bottom-right) ──
    LifetreeNode(
      id: 'soundscape_cosmic',
      title: 'מסע קוסמי',
      description: 'נוף קולי של חלל עמוק '
          'למדיטציה והרפיה.',
      category: LifetreeCategory.soundscapes,
      unlockCondition: LifetreeUnlockCondition(minStreakDays: 21),
      position: Offset(0.7, 0.7),
      isComingSoon: true,
    ),
    LifetreeNode(
      id: 'soundscape_nebula',
      title: 'גשם ערפילית',
      description: 'גשם אתרי המסונן דרך ערפילית. '
          'מושלם לשינה ולריכוז.',
      category: LifetreeCategory.soundscapes,
      unlockCondition: LifetreeUnlockCondition(minStreakDays: 30),
      position: Offset(0.8, 0.82),
      isComingSoon: true,
    ),
  ];

  /// Check if a node's conditions are met.
  static bool isUnlockable(
    LifetreeNode node, {
    required int streakDays,
    required int exercises,
    required int journalEntries,
  }) {
    final c = node.unlockCondition;
    return streakDays >= c.minStreakDays &&
        exercises >= c.minExercises &&
        journalEntries >= c.minJournalEntries;
  }

  /// Nodes filtered by category.
  static List<LifetreeNode> nodesForCategory(LifetreeCategory category) {
    return nodes.where((n) => n.category == category).toList();
  }

  /// Finds a node by ID.
  static LifetreeNode? nodeById(String id) {
    for (final node in nodes) {
      if (node.id == id) return node;
    }
    return null;
  }

  /// Connections between nodes (for constellation lines).
  /// Each pair represents two node IDs that should be visually connected.
  static const connections = <(String, String)>[
    // Breathing chain
    ('breathing_478', 'breathing_55'),
    ('breathing_55', 'breathing_627'),
    // Journaling chain
    ('journal_deep', 'journal_gratitude'),
    ('journal_gratitude', 'journal_future'),
    // Soundscapes chain
    ('soundscape_cosmic', 'soundscape_nebula'),
  ];
}
