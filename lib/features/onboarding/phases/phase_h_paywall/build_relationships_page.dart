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
              'Build real relationships',
              style: AppTypography.headlineLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _buildBenefit('\u{1F49A}', 'Enhance your emotional intelligence'),
            _buildBenefit('\u{1F49C}', 'Be more trustworthy and dependable'),
            _buildBenefit('\u{2764}', 'Experience real intimacy and connection'),
            _buildBenefit('\u{1F49B}', 'Become the person they deserve'),
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
              '\'Porn was hindering my ability to love, and I see now there was a distance in my relationship. I\'m so glad I turned things around when I did.\'',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
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
