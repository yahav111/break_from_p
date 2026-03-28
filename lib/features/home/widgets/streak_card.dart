import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

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
    return Container(
      width: double.infinity,
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
        children: [
          _buildOrb(),
          const SizedBox(height: AppSpacing.lg),
          _buildSubLabel(),
          const SizedBox(height: AppSpacing.sm),
          _buildDaysCounter(),
          _buildTimeCounter(),
          const SizedBox(height: AppSpacing.xl),
          _buildProgressBar(),
          const SizedBox(height: AppSpacing.xl),
          _buildPanicButton(),
        ],
      ),
    );
  }

  Widget _buildOrb() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFFBE3FD8), Color(0xFF7B61FF), Color(0xFF3A20A0)],
        ),
        boxShadow: AppShadows.primaryGlow,
      ),
    );
  }

  Widget _buildSubLabel() {
    return Text(
      "You've been porn-free for:",
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.darkTextSecondary,
      ),
    );
  }

  Widget _buildDaysCounter() {
    return Text(
      '$days days',
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
              'Brain Rewiring',
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
      ],
    );
  }

  Widget _buildPanicButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        borderRadius: AppRadius.borderPill,
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_rounded, color: AppColors.error, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Panic Button',
            style: AppTypography.button.copyWith(color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
