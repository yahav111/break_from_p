import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';

/// Screen 3: "Let's Go!" with a profile card preview.
class ProfileCardPreviewPage extends StatelessWidget {
  const ProfileCardPreviewPage({
    super.key,
    required this.onNext,
    this.userName,
  });

  final VoidCallback onNext;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final name = (userName?.isNotEmpty == true) ? userName! : 'Friend';
    final now = DateTime.now();
    final dateStr =
        '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';

    return OnboardingPageTemplate(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Sparkle icon
            Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.tertiary,
              size: 40,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Let\'s Go!',
              style: AppTypography.displayLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Welcome to QUITTR. Here\'s your tracked\nprofile card.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            // Gradient profile card
            Container(
              width: 240,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.large),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF667EEA),
                    Color(0xFFFF6B6B),
                    Color(0xFFFF9A56),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'QTR',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.share_rounded,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  Text(
                    'Active Streak',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    '0 days',
                    style: AppTypography.headlineLarge.copyWith(
                      color: Colors.white,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(
                    color: Colors.white24,
                    height: 1,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: AppTypography.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            name,
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Free since',
                            style: AppTypography.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            dateStr,
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(flex: 1),
            Text(
              'Now, let\'s build the app around you.',
              style: AppTypography.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.medium,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              label: 'Next',
              isFullWidth: true,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.large,
              onPressed: onNext,
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
