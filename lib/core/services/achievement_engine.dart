import 'package:flutter/material.dart';

/// Category grouping for achievements.
enum AchievementCategory { streak, pledge, journal, exercise, urge, special }

/// Static definition of an achievement (not persisted — the unlock state is).
class AchievementDef {
  const AchievementDef({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final AchievementCategory category;
}

/// Context data passed to achievement condition checks.
class AchievementContext {
  const AchievementContext({
    this.currentStreakDays = 0,
    this.totalPledges = 0,
    this.currentPledgeStreak = 0,
    this.totalJournalEntries = 0,
    this.journalConsecutiveDays = 0,
    this.totalExercises = 0,
    this.exerciseTypes = const {},
    this.totalUrges = 0,
    this.lifetreeNodesUnlocked = 0,
  });

  final int currentStreakDays;
  final int totalPledges;
  final int currentPledgeStreak;
  final int totalJournalEntries;
  final int journalConsecutiveDays;
  final int totalExercises;
  final Set<String> exerciseTypes;
  final int totalUrges;
  final int lifetreeNodesUnlocked;
}

/// Pure logic for achievement definitions and condition checking.
abstract final class AchievementEngine {
  static const definitions = <AchievementDef>[
    // Streak achievements
    AchievementDef(
      id: 'streak_1',
      title: 'First Step',
      description: 'Completed your first day',
      icon: Icons.directions_walk_rounded,
      category: AchievementCategory.streak,
    ),
    AchievementDef(
      id: 'streak_7',
      title: 'One Week Warrior',
      description: 'Reached a 7-day streak',
      icon: Icons.local_fire_department_rounded,
      category: AchievementCategory.streak,
    ),
    AchievementDef(
      id: 'streak_14',
      title: 'Fortnight Fighter',
      description: 'Reached a 14-day streak',
      icon: Icons.shield_rounded,
      category: AchievementCategory.streak,
    ),
    AchievementDef(
      id: 'streak_30',
      title: 'Monthly Master',
      description: 'Reached a 30-day streak',
      icon: Icons.star_rounded,
      category: AchievementCategory.streak,
    ),
    AchievementDef(
      id: 'streak_60',
      title: 'Double Down',
      description: 'Reached a 60-day streak',
      icon: Icons.bolt_rounded,
      category: AchievementCategory.streak,
    ),
    AchievementDef(
      id: 'streak_90',
      title: 'Brain Rewired',
      description: 'Reached a 90-day streak',
      icon: Icons.psychology_rounded,
      category: AchievementCategory.streak,
    ),

    // Pledge achievements
    AchievementDef(
      id: 'pledge_first',
      title: 'First Promise',
      description: 'Made your first pledge',
      icon: Icons.handshake_rounded,
      category: AchievementCategory.pledge,
    ),
    AchievementDef(
      id: 'pledge_streak_7',
      title: 'Promise Keeper',
      description: '7 consecutive pledge days',
      icon: Icons.verified_rounded,
      category: AchievementCategory.pledge,
    ),
    AchievementDef(
      id: 'pledge_streak_30',
      title: 'Oath of Steel',
      description: '30 consecutive pledge days',
      icon: Icons.workspace_premium_rounded,
      category: AchievementCategory.pledge,
    ),

    // Journal achievements
    AchievementDef(
      id: 'journal_first',
      title: 'Dear Diary',
      description: 'Wrote your first journal entry',
      icon: Icons.edit_note_rounded,
      category: AchievementCategory.journal,
    ),
    AchievementDef(
      id: 'journal_10',
      title: 'Reflective Soul',
      description: 'Wrote 10 journal entries',
      icon: Icons.auto_stories_rounded,
      category: AchievementCategory.journal,
    ),
    AchievementDef(
      id: 'journal_streak_7',
      title: 'Daily Scribe',
      description: 'Journaled 7 days in a row',
      icon: Icons.create_rounded,
      category: AchievementCategory.journal,
    ),

    // Exercise achievements
    AchievementDef(
      id: 'exercise_first',
      title: 'Mindful Beginner',
      description: 'Completed your first exercise',
      icon: Icons.self_improvement_rounded,
      category: AchievementCategory.exercise,
    ),
    AchievementDef(
      id: 'exercise_10',
      title: 'Zen Practitioner',
      description: 'Completed 10 exercises',
      icon: Icons.spa_rounded,
      category: AchievementCategory.exercise,
    ),
    AchievementDef(
      id: 'exercise_all_types',
      title: 'Well-Rounded',
      description: 'Tried every exercise type',
      icon: Icons.all_inclusive_rounded,
      category: AchievementCategory.exercise,
    ),

    // Urge achievements
    AchievementDef(
      id: 'urge_first',
      title: 'Faced the Storm',
      description: 'Tracked your first urge',
      icon: Icons.thunderstorm_rounded,
      category: AchievementCategory.urge,
    ),
    AchievementDef(
      id: 'urge_10',
      title: 'Storm Rider',
      description: 'Tracked 10 urges',
      icon: Icons.surfing_rounded,
      category: AchievementCategory.urge,
    ),

    // Special achievements
    AchievementDef(
      id: 'lifetree_3',
      title: 'Tree Tender',
      description: 'Unlocked 3 Lifetree nodes',
      icon: Icons.park_rounded,
      category: AchievementCategory.special,
    ),
  ];

  /// Returns IDs of newly earned achievements.
  static List<String> checkNewAchievements({
    required Set<String> alreadyUnlocked,
    required AchievementContext context,
  }) {
    final newlyEarned = <String>[];

    for (final def in definitions) {
      if (alreadyUnlocked.contains(def.id)) continue;
      if (_checkCondition(def.id, context)) {
        newlyEarned.add(def.id);
      }
    }

    return newlyEarned;
  }

  /// Finds the definition for an achievement [id].
  static AchievementDef? definitionFor(String id) {
    for (final def in definitions) {
      if (def.id == id) return def;
    }
    return null;
  }

  /// Color for an achievement category.
  static Color categoryColor(AchievementCategory category) {
    return switch (category) {
      AchievementCategory.streak => const Color(0xFFFF9F43),
      AchievementCategory.pledge => const Color(0xFF4ECB71),
      AchievementCategory.journal => const Color(0xFF7B61FF),
      AchievementCategory.exercise => const Color(0xFF4ECBFF),
      AchievementCategory.urge => const Color(0xFFFF6B6B),
      AchievementCategory.special => const Color(0xFFFFD700),
    };
  }

  static bool _checkCondition(String id, AchievementContext ctx) {
    return switch (id) {
      'streak_1' => ctx.currentStreakDays >= 1,
      'streak_7' => ctx.currentStreakDays >= 7,
      'streak_14' => ctx.currentStreakDays >= 14,
      'streak_30' => ctx.currentStreakDays >= 30,
      'streak_60' => ctx.currentStreakDays >= 60,
      'streak_90' => ctx.currentStreakDays >= 90,
      'pledge_first' => ctx.totalPledges >= 1,
      'pledge_streak_7' => ctx.currentPledgeStreak >= 7,
      'pledge_streak_30' => ctx.currentPledgeStreak >= 30,
      'journal_first' => ctx.totalJournalEntries >= 1,
      'journal_10' => ctx.totalJournalEntries >= 10,
      'journal_streak_7' => ctx.journalConsecutiveDays >= 7,
      'exercise_first' => ctx.totalExercises >= 1,
      'exercise_10' => ctx.totalExercises >= 10,
      'exercise_all_types' => ctx.exerciseTypes.length >= 3,
      'urge_first' => ctx.totalUrges >= 1,
      'urge_10' => ctx.totalUrges >= 10,
      'lifetree_3' => ctx.lifetreeNodesUnlocked >= 3,
      _ => false,
    };
  }
}
