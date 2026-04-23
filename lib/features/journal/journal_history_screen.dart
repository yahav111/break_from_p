import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/providers/journal_provider.dart';
import '../../design_system/design_system.dart';
import 'widgets/calendar_view.dart';
import 'widgets/journal_entry_card.dart';

/// Calendar view of journal entries showing a month grid with mood dots.
class JournalHistoryScreen extends ConsumerWidget {
  const JournalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalData = ref.watch(journalNotifierProvider);
    final entries = journalData?.entries ?? [];

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
                      CalendarView(
                        entries: entries,
                        onDaySelected: (date) {
                          _showEntriesForDay(context, entries, date);
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildRecentEntriesSection(entries),
                      const SizedBox(height: AppSpacing.xxl),
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
            'היסטוריית יומן',
            style: AppTypography.headlineSmall.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEntriesSection(List<dynamic> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xxxl),
          child: Column(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 48,
                color: AppColors.darkTextTertiary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'אין עדיין רשומות',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'התחל לכתוב כדי לראות את ההיסטוריה כאן',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.darkTextTertiary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show up to 5 most recent entries below the calendar.
    final recent = entries.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'רשומות אחרונות',
          style: AppTypography.titleMedium.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.md),
        ...recent.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: JournalEntryCard(entry: entry),
          );
        }),
      ],
    );
  }

  void _showEntriesForDay(
    BuildContext context,
    List<dynamic> allEntries,
    DateTime date,
  ) {
    final dayEntries = allEntries.where((e) {
      return e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day;
    }).toList();

    if (dayEntries.isEmpty) return;

    final dateLabel = DateFormat('d בMMMM y', 'he_IL').format(date);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.topXxl,
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.darkTextTertiary,
                    borderRadius: AppRadius.borderPill,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                dateLabel,
                style: AppTypography.titleMedium.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...dayEntries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: JournalEntryCard(entry: entry),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
