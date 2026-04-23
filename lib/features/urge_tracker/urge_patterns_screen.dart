import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/models/urge_entry.dart';
import '../../core/providers/urge_provider.dart';
import '../../design_system/design_system.dart';
import 'widgets/urge_chart.dart';

/// Urge history and pattern visualization screen.
/// Shows summary stats, time-of-day chart, top triggers, and recent entries.
class UrgePatternsScreen extends ConsumerWidget {
  const UrgePatternsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urgeData = ref.watch(urgeNotifierProvider);
    final entries = urgeData?.entries ?? [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                child: entries.isEmpty
                    ? _buildEmptyState()
                    : _buildContent(entries),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
          const SizedBox(width: AppSpacing.md),
          Text(
            'דפוסי דחפים',
            style: AppTypography.titleMedium.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insights_rounded,
              size: 64,
              color: AppColors.darkTextTertiary,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'עדיין לא תועדו דחפים',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'כשתתעד דחפים, דפוסים יופיעו כאן שיעזרו לך להבין את הטריגרים שלך.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<UrgeEntry> entries) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          _buildSummaryCards(entries),
          const SizedBox(height: AppSpacing.xxl),
          _buildTimeOfDaySection(entries),
          const SizedBox(height: AppSpacing.xxl),
          _buildTopTriggersSection(entries),
          const SizedBox(height: AppSpacing.xxl),
          _buildRecentSection(entries),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }

  // ── Summary cards ──

  Widget _buildSummaryCards(List<UrgeEntry> entries) {
    final totalUrges = entries.length;
    final avgIntensity = entries.isEmpty
        ? 0.0
        : entries.map((e) => e.intensity).reduce((a, b) => a + b) /
            entries.length;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'סה״כ דחפים',
            '$totalUrges',
            Icons.trending_up_rounded,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildSummaryCard(
            'עוצמה ממוצעת',
            avgIntensity.toStringAsFixed(1),
            Icons.speed_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.headlineMedium.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Time of Day chart ──

  Widget _buildTimeOfDaySection(List<UrgeEntry> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(
          title: 'שעה ביום',
          showAccent: true,
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: AppRadius.borderLarge,
          ),
          child: UrgeChart(entries: entries),
        ),
      ],
    );
  }

  // ── Top Triggers ──

  Widget _buildTopTriggersSection(List<UrgeEntry> entries) {
    final triggerCounts = <String, int>{};
    for (final entry in entries) {
      triggerCounts[entry.trigger] = (triggerCounts[entry.trigger] ?? 0) + 1;
    }

    final sorted = triggerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxCount = sorted.isEmpty ? 0 : sorted.first.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(
          title: 'טריגרים מובילים',
          showAccent: true,
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: AppRadius.borderLarge,
          ),
          child: Column(
            children: sorted.map((entry) {
              return _buildTriggerBar(
                _formatTriggerLabel(entry.key),
                entry.value,
                maxCount,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTriggerBar(String label, int count, int maxCount) {
    final fraction = maxCount > 0 ? count / maxCount : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth * fraction;
                return Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      height: 20,
                      width: barWidth.clamp(
                        count > 0 ? 4.0 : 0.0,
                        constraints.maxWidth,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tertiary,
                        borderRadius: AppRadius.borderPill,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '$count',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.darkTextSecondary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTriggerLabel(String key) {
    const labels = {
      'boredom': 'שעמום',
      'stress': 'לחץ',
      'loneliness': 'בדידות',
      'anxiety': 'חרדה',
      'habit': 'הרגל',
      'social_media': 'רשתות חברתיות',
      'late_night': 'שעות מאוחרות',
      'other': 'אחר',
    };
    return labels[key] ?? key;
  }

  // ── Recent urges ──

  Widget _buildRecentSection(List<UrgeEntry> entries) {
    final recent = entries.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(
          title: 'אחרונים',
          showAccent: true,
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: AppRadius.borderLarge,
          ),
          child: Column(
            children: [
              for (int i = 0; i < recent.length; i++) ...[
                _buildRecentTile(recent[i]),
                if (i < recent.length - 1)
                  Divider(
                    height: 1,
                    color: AppColors.darkBorderSubtle,
                    indent: AppSpacing.lg,
                    endIndent: AppSpacing.lg,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTile(UrgeEntry entry) {
    final intensityColor = Color.lerp(
      AppColors.secondary,
      AppColors.error,
      (entry.intensity - 1) / 9,
    )!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // Intensity dot
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: intensityColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Date/time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(entry.timestamp),
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'עוצמה: ${entry.intensity}/10',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.darkTextTertiary,
                  ),
                ),
              ],
            ),
          ),
          // Trigger chip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkElevated,
              borderRadius: AppRadius.borderPill,
            ),
            child: Text(
              _formatTriggerLabel(entry.trigger),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'הרגע';
    if (diff.inMinutes < 60) return 'לפני ${diff.inMinutes} דקות';
    if (diff.inHours < 24) return 'לפני ${diff.inHours} שעות';
    if (diff.inDays < 7) return 'לפני ${diff.inDays} ימים';

    return DateFormat('d בMMMM HH:mm', 'he_IL').format(dt);
  }
}
