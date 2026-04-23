import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';
import 'recovery_plan_provider.dart';
import 'widgets/day_plan_card.dart';

/// Recovery plan page: "It's not about willpower."
/// Renders a personalized day-by-day plan derived from the user's quiz
/// answers, with day count and key copy scaled to the user's total recovery
/// duration.
class RecoveryPlanPage extends ConsumerWidget {
  const RecoveryPlanPage({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(recoveryPlanProvider);

    return OnboardingPageTemplate(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          // QUITTR logo
          Text(
            'QUITTER PRO',
            style: AppTypography.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.bold,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Text(
              'זה לא עניין של כוח רצון.',
              style: AppTypography.headlineLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Text(
              'זו מערכת שפשוט עובדת',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Text(
              'QUITTER PRO מלווה אותך בתהליך התאפסות חזק של '
              '${plan.totalDays} ימים, עם מבנה וכלים שתומכים בצמיחה שלך '
              'גם מעבר לתקופת ההתנזרות.\n\n'
              'הנה איך נראים 7 הימים הראשונים שלך:',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.darkTextSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              children: [
                for (final d in plan.dayPlan)
                  DayPlanCard(
                    title: d.dayLabel,
                    description: d.description,
                    icon: d.icon,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'ללא התחייבות, ניתן לבטל בכל עת',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                GradientButton(
                  label: 'התחל את המסע שלי היום',
                  isFullWidth: true,
                  size: AppButtonSize.large,
                  onPressed: onNext,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
