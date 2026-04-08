import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_background.dart';
import '../../widgets/onboarding_page_template.dart';

/// "Welcome to QUITTR, your..." intro/video placeholder page.
class WelcomeVideoPage extends StatelessWidget {
  const WelcomeVideoPage({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNext,
      child: OnboardingPageTemplate(
        variant: OnboardingBackgroundVariant.teal,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome to\nQUITTR, your',
                textAlign: TextAlign.center,
                style: AppTypography.displayLarge.copyWith(
                  color: Colors.white,
                  fontWeight: AppTypography.bold,
                  fontSize: 34,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxxxl),
              // Play button placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 40,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxxxl),
              Text(
                'Tap to continue',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
