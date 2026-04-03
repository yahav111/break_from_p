import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../design_system/design_system.dart';
import '../../../routing/route_names.dart';

/// Coping tools shown during the "I'm thinking of relapsing" panic flow.
/// Provides real navigation to breathing exercises, journal, and meditation.
class CopingTools extends StatelessWidget {
  const CopingTools({
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
          context,
          icon: Icons.air_rounded,
          title: 'Breathing Exercise',
          subtitle: '4-4-4 box breathing to calm your mind',
          color: AppColors.secondary,
          onTap: () => context.push(Routes.breathingExercise),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildToolCard(
          context,
          icon: Icons.edit_note_rounded,
          title: 'Journal Entry',
          subtitle: 'Write about what you\'re feeling',
          color: AppColors.tertiary,
          onTap: () => context.push(Routes.journalEntry),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildToolCard(
          context,
          icon: Icons.self_improvement_rounded,
          title: 'Guided Meditation',
          subtitle: 'Exercises to regain control',
          color: AppColors.primary,
          onTap: () => context.push(Routes.meditate),
        ),
      ],
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.darkTextTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
