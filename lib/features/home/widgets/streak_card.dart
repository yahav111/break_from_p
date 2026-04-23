import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import 'day_orbs_row.dart';
import 'milestone_indicator.dart';

/// Streak/progress hero card shown at the top of the Home screen.
class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.days,
    required this.timeLabel,
    required this.brainRewirePct,
  });

  final int days;
  final String timeLabel;
  final double brainRewirePct;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DayOrbsRow(days: days),
        const SizedBox(height: AppSpacing.md),
        _buildSubLabel(),
        const SizedBox(height: AppSpacing.sm),
        _buildDaysCounter(),
        _buildTimeCounter(),
        const SizedBox(height: AppSpacing.xl),
        _buildProgressBar(),
      ],
    );
  }

  Widget _buildSubLabel() {
    return Text(
      'אתה נקי מפורנו כבר:',
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.darkTextSecondary,
      ),
    );
  }

  Widget _buildDaysCounter() {
    return Text(
      '$days ימים',
      style: AppTypography.displayLarge.copyWith(
        color: Colors.white,
        fontSize: 44,
        fontWeight: AppTypography.bold,
      ),
    );
  }

  Widget _buildTimeCounter() {
    return Text(
      timeLabel,
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.darkTextSecondary,
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'חיווט המוח מחדש',
              style: AppTypography.caption.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            Text(
              '${(brainRewirePct * 100).round()}%',
              style: AppTypography.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTypography.semiBold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: AppRadius.borderPill,
          child: LinearProgressIndicator(
            value: brainRewirePct,
            minHeight: 8,
            backgroundColor: AppColors.darkElevated,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        MilestoneIndicator(currentDays: days),
      ],
    );
  }

}
