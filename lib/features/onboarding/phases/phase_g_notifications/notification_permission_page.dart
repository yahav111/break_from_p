import 'package:flutter/material.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';

/// Notification permission request screen.
class NotificationPermissionPage extends StatelessWidget {
  const NotificationPermissionPage({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      starDensity: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 2),
            Text(
              'תישאר במסלול\nעם תזכורות',
              style: AppTypography.displayLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
                fontSize: 32,
                height: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'קבל תזכורות ומוטיבציה עדינות כדי שלא תאבד את הפוקוס על המטרות שלך.',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.darkTextSecondary,
                height: 1.5,
              ),
            ),
            const Spacer(flex: 3),
            AppButton(
              label: 'הפעל התראות',
              isFullWidth: true,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.large,
              onPressed: () async {
                await NotificationService().requestPermission();
                onComplete();
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: AppButton(
                label: 'לא עכשיו',
                variant: AppButtonVariant.ghost,
                size: AppButtonSize.medium,
                onPressed: onComplete,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxxxl),
          ],
        ),
      ),
    );
  }
}
