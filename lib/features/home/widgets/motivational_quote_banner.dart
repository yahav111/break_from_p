import 'package:flutter/material.dart';

import '../../../core/services/quotes_engine.dart';
import '../../../design_system/design_system.dart';

/// Dark-themed card displaying a daily motivational quote.
class MotivationalQuoteBanner extends StatelessWidget {
  const MotivationalQuoteBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays + 1;
    final quote = QuotesEngine.quoteForDay(dayOfYear);
    final author = QuotesEngine.authorForDay(dayOfYear);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderLarge,
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: AppColors.primary.withValues(alpha: 0.6),
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkTextSecondary,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
                if (author != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '- $author',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.darkTextTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
