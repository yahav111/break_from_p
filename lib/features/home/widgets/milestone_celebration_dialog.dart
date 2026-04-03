import 'package:flutter/material.dart';

import '../../../core/models/milestone_info.dart';
import '../../../design_system/design_system.dart';

/// Celebration dialog shown when a new brain rewire milestone is reached.
class MilestoneCelebrationDialog extends StatelessWidget {
  const MilestoneCelebrationDialog({
    super.key,
    required this.milestone,
  });

  final MilestoneInfo milestone;

  /// Shows the celebration dialog.
  static Future<void> show(BuildContext context, MilestoneInfo milestone) {
    return showDialog(
      context: context,
      builder: (_) => MilestoneCelebrationDialog(milestone: milestone),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1255), Color(0xFF2D1880)],
          ),
          borderRadius: AppRadius.borderExtraLarge,
          border: Border.all(color: AppColors.darkBorder),
          boxShadow: AppShadows.primaryGlow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trophy icon.
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFFBE3FD8), Color(0xFF7B61FF)],
                ),
                boxShadow: AppShadows.primaryGlow,
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Title.
            Text(
              '${milestone.days} Days!',
              style: AppTypography.displayLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              milestone.title,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              milestone.description,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Science message.
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.darkCard.withValues(alpha: 0.5),
                borderRadius: AppRadius.borderMedium,
              ),
              child: Text(
                milestone.scienceMessage,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.darkTextSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Dismiss button.
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Keep Going',
                variant: AppButtonVariant.gradient,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
