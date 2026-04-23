import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/exercise_provider.dart';
import '../../design_system/design_system.dart';
import '../../routing/route_names.dart';

/// Exercise list screen. Pushed from Library "Meditate" card.
class MeditateScreen extends ConsumerWidget {
  const MeditateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseData = ref.watch(exerciseNotifierProvider);
    final records = exerciseData?.records ?? [];

    int countFor(String type) =>
        records.where((r) => r.exerciseType == type).length;

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
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      _buildExerciseCard(
                        context: context,
                        icon: Icons.air_rounded,
                        iconColor: AppColors.secondary,
                        title: 'תרגיל נשימה',
                        subtitle: 'נשימת קופסה 4-4-4 \u00b7 דקה אחת',
                        completions: countFor('breathing'),
                        onTap: () => context.push(Routes.breathingExercise),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildExerciseCard(
                        context: context,
                        icon: Icons.waves_rounded,
                        iconColor: AppColors.primary,
                        title: 'גלישה על דחף',
                        subtitle: 'גלישה על הגל \u00b7 3 דקות',
                        completions: countFor('urge_surfing'),
                        onTap: () => context.push(Routes.urgeSurfing),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildExerciseCard(
                        context: context,
                        icon: Icons.spa_rounded,
                        iconColor: AppColors.tertiary,
                        title: 'הארקה 5-4-3-2-1',
                        subtitle: 'מודעות חושית \u00b7 2 דקות',
                        completions: countFor('grounding'),
                        onTap: () => context.push(Routes.grounding),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildExerciseCard(
                        context: context,
                        icon: Icons.accessibility_new_rounded,
                        iconColor: AppColors.info,
                        title: 'סריקת גוף',
                        subtitle: 'מודעות מודרכת \u00b7 3 דקות',
                        completions: countFor('body_scan'),
                        onTap: () => context.push(Routes.bodyScan),
                      ),
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
            'מדיטציה',
            style: AppTypography.headlineSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required int completions,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: AppRadius.borderLarge,
          border: Border.all(color: AppColors.darkBorderSubtle),
        ),
        child: Row(
          children: [
            // Icon bubble.
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderMedium,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: AppSpacing.lg),

            // Title + subtitle.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleSmall.copyWith(
                      color: Colors.white,
                    ),
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

            // Completion badge.
            if (completions > 0) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                '$completions פעמים',
                style: AppTypography.caption.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],

            // Chevron.
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
