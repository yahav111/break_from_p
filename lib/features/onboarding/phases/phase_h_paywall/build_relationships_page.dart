import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';

/// "Build real relationships" benefits + testimonial page.
class BuildRelationshipsPage extends StatelessWidget {
  const BuildRelationshipsPage({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xxxxxl),
            // Illustration placeholder
            Icon(
              Icons.people_rounded,
              size: 80,
              color: AppColors.secondary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Text(
              'בנה מערכות יחסים אמיתיות',
              style: AppTypography.headlineLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _buildBenefit('\u{1F49A}', 'שפר את האינטליגנציה הרגשית שלך'),
            _buildBenefit('\u{1F49C}', 'היה אמין ויציב יותר'),
            _buildBenefit('\u{2764}', 'חווה אינטימיות וקשר אמיתיים'),
            _buildBenefit('\u{1F49B}', 'היה האדם שהם ראויים לו'),
            const SizedBox(height: AppSpacing.xxl),
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (_) => const Icon(Icons.star_rounded,
                    color: Color(0xFFFFD700), size: 24),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Quote
            Text(
              '"הפורנו פגע ביכולת שלי לאהוב, ואני רואה היום שהיה מרחק במערכת היחסים שלי. אני כל כך שמח ששיניתי את זה בזמן."',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            AppButton(
              label: 'הפוך ל-QUITTR',
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

  Widget _buildBenefit(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyLarge.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
