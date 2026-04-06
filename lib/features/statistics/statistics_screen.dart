import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/exercise_provider.dart';
import '../../core/providers/journal_provider.dart';
import '../../core/providers/pledge_provider.dart';
import '../../core/providers/streak_provider.dart';
import '../../core/providers/urge_provider.dart';
import '../../core/services/stats_engine.dart';
import '../../core/services/streak_engine.dart';
import '../../design_system/design_system.dart';
import 'widgets/exercise_pie_chart.dart';
import 'widgets/mood_trend_chart.dart';
import 'widgets/streak_history_chart.dart';

/// Full-screen statistics dashboard showing recovery metrics.
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakNotifierProvider);
    final pledge = ref.watch(pledgeNotifierProvider);
    final journal = ref.watch(journalNotifierProvider);
    final urge = ref.watch(urgeNotifierProvider);
    final exercise = ref.watch(exerciseNotifierProvider);

    // Computed stats.
    final totalDays = StatsEngine.totalCleanDays(streak);
    final longest = StatsEngine.longestStreak(streak);
    final avgStreak = StatsEngine.averageStreakLength(streak);
    final streakLengths = StatsEngine.streakHistoryLengths(streak);
    final moodData = StatsEngine.moodTrend(journal);
    final exerciseCounts = StatsEngine.exerciseBreakdown(exercise);
    final pledgeRate = StatsEngine.pledgeRate(pledge, totalDays);
    final journalPerWeek = StatsEngine.journalFrequency(journal, totalDays);
    final urgeHours = StatsEngine.urgesByHour(urge);

    // Determine peak urge hour.
    String peakHourLabel = '--';
    if (urgeHours.isNotEmpty) {
      final peakHour = urgeHours.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      peakHourLabel = _formatHour(peakHour);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0D2E), Color(0xFF080B22)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.lg),

                      // Top stat cards row.
                      _buildStatCardsRow(
                        totalDays: totalDays,
                        longestStreak: longest,
                        avgStreak: avgStreak,
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Streak History section.
                      _buildSectionTitle('Streak History'),
                      const SizedBox(height: AppSpacing.md),
                      StreakHistoryChart(streakLengths: streakLengths),
                      const SizedBox(height: AppSpacing.xxl),

                      // Mood Trends section.
                      _buildSectionTitle('Mood Trends'),
                      const SizedBox(height: AppSpacing.md),
                      MoodTrendChart(moodData: moodData),
                      const SizedBox(height: AppSpacing.xxl),

                      // Exercises section.
                      _buildSectionTitle('Exercises'),
                      const SizedBox(height: AppSpacing.md),
                      ExercisePieChart(exerciseCounts: exerciseCounts),
                      const SizedBox(height: AppSpacing.xxl),

                      // Additional stats section.
                      _buildSectionTitle('Insights'),
                      const SizedBox(height: AppSpacing.md),
                      _buildInsightsCard(
                        pledgeRate: pledgeRate,
                        journalPerWeek: journalPerWeek,
                        peakHourLabel: peakHourLabel,
                        currentDays: streak != null
                            ? StreakEngine.daysSince(streak.quitDate)
                            : 0,
                      ),
                      const SizedBox(height: AppSpacing.xxxxl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // App bar
  // ---------------------------------------------------------------------------

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.overlayWhiteSubtle,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Text(
            'Statistics',
            style: AppTypography.headlineSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top stat cards
  // ---------------------------------------------------------------------------

  Widget _buildStatCardsRow({
    required int totalDays,
    required int longestStreak,
    required double avgStreak,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            label: 'Total Clean Days',
            value: totalDays.toString(),
            icon: Icons.calendar_today_rounded,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildStatCard(
            label: 'Longest Streak',
            value: '${longestStreak}d',
            icon: Icons.emoji_events_rounded,
            color: AppColors.tertiary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildStatCard(
            label: 'Avg Streak',
            value: '${avgStreak.toStringAsFixed(1)}d',
            icon: Icons.show_chart_rounded,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderLarge,
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.statsValue.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.statsLabel
                .copyWith(color: AppColors.darkTextTertiary),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section title
  // ---------------------------------------------------------------------------

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.titleSmall.copyWith(color: Colors.white),
    );
  }

  // ---------------------------------------------------------------------------
  // Insights card
  // ---------------------------------------------------------------------------

  Widget _buildInsightsCard({
    required double pledgeRate,
    required double journalPerWeek,
    required String peakHourLabel,
    required int currentDays,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderLarge,
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Column(
        children: [
          _buildInsightRow(
            icon: Icons.handshake_rounded,
            label: 'Pledge Rate',
            value: '${(pledgeRate * 100).toStringAsFixed(0)}%',
            color: AppColors.secondary,
          ),
          const Divider(color: AppColors.darkBorderSubtle, height: 24),
          _buildInsightRow(
            icon: Icons.auto_stories_rounded,
            label: 'Journal / week',
            value: journalPerWeek.toStringAsFixed(1),
            color: AppColors.primary,
          ),
          const Divider(color: AppColors.darkBorderSubtle, height: 24),
          _buildInsightRow(
            icon: Icons.access_time_rounded,
            label: 'Urge Peak Hour',
            value: peakHourLabel,
            color: AppColors.tertiary,
          ),
          const Divider(color: AppColors.darkBorderSubtle, height: 24),
          _buildInsightRow(
            icon: Icons.local_fire_department_rounded,
            label: 'Current Streak',
            value: '${currentDays}d',
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.darkTextSecondary),
          ),
        ),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _formatHour(int hour) {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final period = hour < 12 ? 'AM' : 'PM';
    return '$h $period';
  }
}
