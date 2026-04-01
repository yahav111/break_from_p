import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Placeholder screen for Phase 3 coping tools.
/// Shows 3 cards for breathing, journal, meditation — all "Coming soon".
class CopingPlaceholder extends StatelessWidget {
  const CopingPlaceholder({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button.
        GestureDetector(
          onTap: onBack,
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
        const SizedBox(height: AppSpacing.xxl),

        Text(
          'Coping Tools',
          style: AppTypography.headlineMedium.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Choose a tool to help you through this moment',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        _buildToolCard(
          icon: Icons.air_rounded,
          title: 'Breathing Exercise',
          subtitle: 'Coming in Phase 3',
          color: AppColors.secondary,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildToolCard(
          icon: Icons.edit_note_rounded,
          title: 'Journal Entry',
          subtitle: 'Coming in Phase 3',
          color: AppColors.tertiary,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildToolCard(
          icon: Icons.self_improvement_rounded,
          title: 'Guided Meditation',
          subtitle: 'Coming in Phase 3',
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderLarge,
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppRadius.borderMedium,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      AppTypography.titleSmall.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.darkTextTertiary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.lock_outline_rounded,
            color: AppColors.darkTextTertiary,
            size: 18,
          ),
        ],
      ),
    );
  }
}
