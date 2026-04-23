import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';
import 'recovery_plan_provider.dart';
import 'widgets/benefit_chip.dart';

/// "We've made you a custom plan" screen with a personalized quit date and
/// goal-driven benefit chips.
class CustomPlanPage extends ConsumerWidget {
  const CustomPlanPage({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(recoveryPlanProvider);
    final quitDate = plan.estimatedQuitDate;
    const months = [
      'ינואר', 'פברואר', 'מרץ', 'אפריל', 'מאי', 'יוני',
      'יולי', 'אוגוסט', 'ספטמבר', 'אוקטובר', 'נובמבר', 'דצמבר',
    ];
    final dateStr =
        '${quitDate.day} ב${months[quitDate.month - 1]}, ${quitDate.year}';

    return OnboardingPageTemplate(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xxxxxl),
            Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 40),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'כן, הכנו לך\nתוכנית מותאמת אישית.',
              textAlign: TextAlign.center,
              style: AppTypography.headlineLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'אתה תיגמל מפורנו עד:',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.borderPill,
              ),
              child: Text(
                dateStr,
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.darkBackground,
                  fontWeight: AppTypography.bold,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (_) => const Icon(Icons.star_rounded,
                    color: Color(0xFFFFD700), size: 24),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'הפוך לגרסה הטובה\nשל עצמך עם QUITTER PRO',
              textAlign: TextAlign.center,
              style: AppTypography.headlineMedium.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'חזק יותר. בריא יותר. מאושר יותר.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Benefit chips generated from the user's goals + plan severity.
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: [
                for (final b in plan.benefits)
                  BenefitChip(
                    label: b.label,
                    emoji: b.emoji,
                    color: b.color,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxxl),
            AppButton(
              label: 'הפוך ל-QUITTER',
              isFullWidth: true,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.large,
              onPressed: onNext,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'הרכישה מופיעה בדיסקרטיות\nניתן לבטל בכל עת \u{2705} סוף סוף להיגמל מפורנו \u{1F337}',
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(
                color: AppColors.darkTextTertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
