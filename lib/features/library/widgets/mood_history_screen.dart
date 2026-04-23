import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/journal_provider.dart';
import '../../../core/providers/urge_provider.dart';
import '../../../design_system/design_system.dart';
import '../../../routing/route_names.dart';

/// Mood & urge summary screen pushed from the Library "Mood" card.
///
/// Shows a 7-day mood row from journal entries, quick action cards,
/// and an urge summary for the current week.
class MoodHistoryScreen extends ConsumerWidget {
  const MoodHistoryScreen({super.key});

  // Mood icon definitions (index matches JournalEntry.mood 0–4).
  static const _moodIcons = [
    Icons.sentiment_very_dissatisfied_rounded, // 0 – bad
    Icons.sentiment_dissatisfied_rounded, // 1 – struggling
    Icons.sentiment_neutral_rounded, // 2 – okay
    Icons.sentiment_satisfied_rounded, // 3 – good
    Icons.sentiment_very_satisfied_rounded, // 4 – great
  ];

  static const _moodColors = [
    AppColors.error, // 0
    AppColors.tertiary, // 1
    AppColors.darkTextSecondary, // 2
    AppColors.secondary, // 3
    AppColors.primary, // 4
  ];

  static const _moodLabels = ['רע', 'קשה', 'בסדר', 'טוב', 'מעולה'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalData = ref.watch(journalNotifierProvider);
    final urgeData = ref.watch(urgeNotifierProvider);

    final entries = journalData?.entries ?? [];
    final urges = urgeData?.entries ?? [];

    // Compute 7-day window.
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 6));

    // Map each of the last 7 days to its most recent journal mood (if any).
    final dayMoods = <DateTime, int?>{};
    for (var i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayKey = DateTime(day.year, day.month, day.day);
      dayMoods[dayKey] = null;
    }
    for (final entry in entries) {
      final dayKey =
          DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (dayMoods.containsKey(dayKey) && dayMoods[dayKey] == null) {
        dayMoods[dayKey] = entry.mood;
      }
    }

    // Average mood for the week (only days with entries).
    final moodValues = dayMoods.values.whereType<int>().toList();
    final avgMood = moodValues.isEmpty
        ? null
        : (moodValues.reduce((a, b) => a + b) / moodValues.length);

    // Urges this week.
    final weekUrges = urges.where((u) => u.timestamp.isAfter(weekStart));
    final urgeCount = weekUrges.length;

    final hasData = entries.isNotEmpty || urges.isNotEmpty;

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
                child: hasData
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSpacing.lg),
                            _buildMoodSection(dayMoods, avgMood),
                            const SizedBox(height: AppSpacing.xxl),
                            _buildQuickActions(context),
                            const SizedBox(height: AppSpacing.xxl),
                            _buildUrgeSummary(urgeCount),
                            const SizedBox(height: AppSpacing.xxxl),
                          ],
                        ),
                      )
                    : _buildEmptyState(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── App bar ──────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
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
          const SizedBox(width: AppSpacing.md),
          Text(
            'מצב רוח ודחפים',
            style: AppTypography.titleMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ── Mood summary ─────────────────────────────────────────────

  Widget _buildMoodSection(Map<DateTime, int?> dayMoods, double? avgMood) {
    final dayNames = ['ב׳', 'ג׳', 'ד׳', 'ה׳', 'ו׳', 'ש׳', 'א׳'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '7 הימים האחרונים',
          style: AppTypography.titleSmall.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: dayMoods.entries.map((e) {
            final mood = e.value;
            final dayIndex = e.key.weekday - 1; // 0=Mon … 6=Sun
            return Column(
              children: [
                Text(
                  dayNames[dayIndex],
                  style: AppTypography.caption.copyWith(
                    color: AppColors.darkTextTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (mood != null)
                  Icon(
                    _moodIcons[mood.clamp(0, 4)],
                    color: _moodColors[mood.clamp(0, 4)],
                    size: 28,
                  )
                else
                  Text(
                    '\u2014',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.darkTextTertiary,
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (avgMood != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: AppRadius.borderMedium,
            ),
            child: Text(
              'מצב רוח ממוצע: ${_moodLabels[avgMood.round().clamp(0, 4)]}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  // ── Quick actions ────────────────────────────────────────────

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'פעולות מהירות',
          style: AppTypography.titleSmall.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildActionCard(
          icon: Icons.flash_on_rounded,
          iconColor: AppColors.tertiary,
          label: 'תעד דחף',
          onTap: () => context.push(Routes.urgeTracker),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildActionCard(
          icon: Icons.edit_note_rounded,
          iconColor: AppColors.secondary,
          label: 'כתוב ביומן',
          onTap: () => context.push(Routes.journalEntry),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: AppRadius.borderLarge,
          border: Border.all(color: AppColors.darkBorderSubtle),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderMedium,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLarge.copyWith(color: Colors.white),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.darkTextTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ── Urge summary ─────────────────────────────────────────────

  Widget _buildUrgeSummary(int urgeCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'סיכום דחפים',
          style: AppTypography.titleSmall.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: AppRadius.borderLarge,
            border: Border.all(color: AppColors.darkBorderSubtle),
          ),
          child: urgeCount > 0
              ? Column(
                  children: [
                    Text(
                      '$urgeCount',
                      style: AppTypography.statsValue.copyWith(
                        color: AppColors.tertiary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      urgeCount == 1
                          ? 'דחף שתועד השבוע'
                          : 'דחפים שתועדו השבוע',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.darkTextSecondary,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.secondary,
                      size: 36,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'לא תועדו דחפים השבוע. עבודה מצוינת!',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.darkTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  // ── Empty state ──────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insights_rounded,
              color: AppColors.primary,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'התחל לעקוב כדי לראות תובנות כאן',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.darkTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            GestureDetector(
              onTap: () => context.push(Routes.journalEntry),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxl,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppRadius.borderPill,
                ),
                child: Text(
                  'כתוב רשומה ראשונה',
                  style: AppTypography.button.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
