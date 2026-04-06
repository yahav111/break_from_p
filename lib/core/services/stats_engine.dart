import '../models/exercise_data.dart';
import '../models/journal_data.dart';
import '../models/pledge_data.dart';
import '../models/streak_data.dart';
import '../models/urge_data.dart';

/// Pure computation functions for statistics dashboard.
/// All methods are static — no state, no dependencies.
abstract final class StatsEngine {
  /// Total clean days across all streaks (current + history).
  static int totalCleanDays(StreakData? streak) {
    if (streak == null) return 0;
    final currentDays = DateTime.now().difference(streak.quitDate).inDays;
    final historyDays =
        streak.streakHistory.fold<int>(0, (sum, r) => sum + r.days);
    return currentDays + historyDays;
  }

  /// Average streak length across all recorded streaks.
  static double averageStreakLength(StreakData? streak) {
    if (streak == null) return 0;
    final current = DateTime.now().difference(streak.quitDate).inDays;
    final lengths = [
      current,
      ...streak.streakHistory.map((r) => r.days),
    ];
    if (lengths.isEmpty) return 0;
    return lengths.reduce((a, b) => a + b) / lengths.length;
  }

  /// Longest streak ever recorded.
  static int longestStreak(StreakData? streak) {
    if (streak == null) return 0;
    final current = DateTime.now().difference(streak.quitDate).inDays;
    final historyMax = streak.streakHistory.isEmpty
        ? 0
        : streak.streakHistory
            .map((r) => r.days)
            .reduce((a, b) => a > b ? a : b);
    return current > historyMax ? current : historyMax;
  }

  /// Pledge completion rate as 0.0–1.0.
  static double pledgeRate(PledgeData? pledge, int totalDays) {
    if (pledge == null || totalDays <= 0) return 0;
    return (pledge.pledgeDates.length / totalDays).clamp(0.0, 1.0);
  }

  /// Journal entries per week (total entries / weeks elapsed).
  static double journalFrequency(JournalData? journal, int totalDays) {
    if (journal == null || totalDays <= 0) return 0;
    final weeks = (totalDays / 7).ceil();
    if (weeks <= 0) return 0;
    return journal.entries.length / weeks;
  }

  /// List of streak lengths for the bar chart (history + current).
  static List<int> streakHistoryLengths(StreakData? streak) {
    if (streak == null) return [];
    final result = streak.streakHistory.map((r) => r.days).toList();
    final current = DateTime.now().difference(streak.quitDate).inDays;
    result.add(current);
    return result;
  }

  /// Mood values over time for the line chart.
  /// Returns list of (date, mood) pairs, sorted by date.
  static List<(DateTime, int)> moodTrend(JournalData? journal,
      {int lastNDays = 30}) {
    if (journal == null) return [];
    final cutoff = DateTime.now().subtract(Duration(days: lastNDays));
    final entries = journal.entries
        .where((e) => e.date.isAfter(cutoff))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return entries.map((e) => (e.date, e.mood)).toList();
  }

  /// Exercise count by type for the pie chart.
  static Map<String, int> exerciseBreakdown(ExerciseData? exercise) {
    if (exercise == null) return {};
    final counts = <String, int>{};
    for (final record in exercise.records) {
      counts[record.exerciseType] =
          (counts[record.exerciseType] ?? 0) + 1;
    }
    return counts;
  }

  /// Urge count by hour of day (0-23).
  static Map<int, int> urgesByHour(UrgeData? urge) {
    if (urge == null) return {};
    final counts = <int, int>{};
    for (final entry in urge.entries) {
      final hour = entry.timestamp.hour;
      counts[hour] = (counts[hour] ?? 0) + 1;
    }
    return counts;
  }

  /// Urge count by day of week (1=Mon, 7=Sun).
  static Map<int, int> urgesByDayOfWeek(UrgeData? urge) {
    if (urge == null) return {};
    final counts = <int, int>{};
    for (final entry in urge.entries) {
      final day = entry.timestamp.weekday;
      counts[day] = (counts[day] ?? 0) + 1;
    }
    return counts;
  }

  /// Best day of week (fewest urges). Returns weekday 1-7 or null.
  static int? bestDayOfWeek(UrgeData? urge) {
    final counts = urgesByDayOfWeek(urge);
    if (counts.isEmpty) return null;
    var bestDay = counts.keys.first;
    for (final entry in counts.entries) {
      if (entry.value < counts[bestDay]!) bestDay = entry.key;
    }
    return bestDay;
  }
}
