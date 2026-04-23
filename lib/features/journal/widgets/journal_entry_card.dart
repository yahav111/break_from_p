import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/journal_entry.dart';
import '../../../design_system/design_system.dart';

/// Card showing a journal entry preview in the list.
class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({
    super.key,
    required this.entry,
    this.onTap,
  });

  final JournalEntry entry;
  final VoidCallback? onTap;

  static const _moodIcons = <int, IconData>{
    0: Icons.sentiment_very_dissatisfied,
    1: Icons.sentiment_dissatisfied,
    2: Icons.sentiment_neutral,
    3: Icons.sentiment_satisfied,
    4: Icons.sentiment_very_satisfied,
  };

  static const _moodColors = <int, Color>{
    0: AppColors.error,
    1: AppColors.tertiary,
    2: AppColors.darkTextSecondary,
    3: AppColors.secondary,
    4: AppColors.primary,
  };

  @override
  Widget build(BuildContext context) {
    final icon = _moodIcons[entry.mood] ?? Icons.sentiment_neutral;
    final color = _moodColors[entry.mood] ?? AppColors.darkTextSecondary;
    final dateText = DateFormat('d בMMMM y', 'he_IL').format(entry.date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: AppRadius.borderLarge,
          border: Border.all(color: AppColors.darkBorderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: mood icon + date.
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  dateText,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.darkTextTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Content preview.
            Text(
              entry.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),

            // Prompt text if present.
            if (entry.prompt != null && entry.prompt!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                entry.prompt!,
                style: AppTypography.caption.copyWith(
                  color: AppColors.darkTextTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
