import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';
import 'widgets/benefit_chip.dart';

/// "We've made you a custom plan" screen with quit date + benefit chips.
class CustomPlanPage extends StatelessWidget {
  const CustomPlanPage({
    super.key,
    required this.onNext,
    this.userName,
  });

  final VoidCallback onNext;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final quitDate = DateTime.now().add(const Duration(days: 90));
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final dateStr = '${months[quitDate.month - 1]} ${quitDate.day}, ${quitDate.year}';

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
              'Yep, we\'ve made you a\ncustom plan.',
              textAlign: TextAlign.center,
              style: AppTypography.headlineLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'You will quit porn by:',
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
              'Become the best of\nyourself with QUITTR',
              textAlign: TextAlign.center,
              style: AppTypography.headlineMedium.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Stronger. Healthier. Happier.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Benefit chips
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: const [
                BenefitChip(
                    label: 'Increased Testosterone',
                    emoji: '\u{1F4AA}',
                    color: Color(0xFF4CAF50)),
                BenefitChip(
                    label: 'Prevent Erectile Dysfunction',
                    emoji: '\u{1F6E1}',
                    color: Color(0xFFF44336)),
                BenefitChip(
                    label: 'Increased Energy',
                    emoji: '\u{26A1}',
                    color: Color(0xFFFFC107)),
                BenefitChip(
                    label: 'Increased Motivation',
                    emoji: '\u{1F525}',
                    color: Color(0xFFFF9800)),
                BenefitChip(
                    label: 'Improved Focus',
                    emoji: '\u{1F3AF}',
                    color: Color(0xFF2196F3)),
                BenefitChip(
                    label: 'Improved Relationships',
                    emoji: '\u{2764}',
                    color: Color(0xFFE91E63)),
                BenefitChip(
                    label: 'Increased Confidence',
                    emoji: '\u{1F451}',
                    color: Color(0xFF9C27B0)),
              ],
            ),
            const SizedBox(height: AppSpacing.xxxl),
            AppButton(
              label: 'Become a QUITTR',
              isFullWidth: true,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.large,
              onPressed: onNext,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Purchase appears Discretely\nCancel Anytime \u{2705} Finally Quit Porn \u{1F337}',
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
