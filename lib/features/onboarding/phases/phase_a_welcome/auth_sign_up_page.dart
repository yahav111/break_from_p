import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../infrastructure/auth/auth_provider.dart';
import '../../../../infrastructure/auth/auth_state.dart';
import '../../../auth/widgets/social_sign_in_button.dart';
import '../../widgets/onboarding_background.dart';
import '../../widgets/onboarding_page_template.dart';

/// Screen 2: "Become a QUITTR" — social sign-in or skip.
class AuthSignUpPage extends ConsumerWidget {
  const AuthSignUpPage({
    super.key,
    required this.onComplete,
    required this.onSignIn,
  });

  final VoidCallback onComplete;

  /// Navigate to sign-in flow (for returning users).
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    // Auto-advance on successful auth.
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (prev?.status != AuthStatus.authenticated &&
          next.status == AuthStatus.authenticated) {
        onComplete();
      }
    });

    return OnboardingPageTemplate(
      variant: OnboardingBackgroundVariant.teal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Phone mockups placeholder
            Container(
              height: 220,
              alignment: Alignment.center,
              child: Icon(
                Icons.phone_iphone_rounded,
                size: 100,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Text(
              'Become a QUITTR',
              style: AppTypography.displayLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
                fontSize: 32,
              ),
            ),
            const Spacer(flex: 1),
            // Apple sign in (placeholder — commented out matching existing pattern)
            SocialSignInButton(
              label: 'Continue with Apple',
              icon: Icons.apple_rounded,
              isLoading: authState.isLoading,
              onPressed: () {
                // TODO: Enable once Apple Developer Program is activated.
              },
            ),
            const SizedBox(height: AppSpacing.md),
            SocialSignInButton(
              label: 'Continue with Google',
              icon: Icons.g_mobiledata_rounded,
              isLoading: authState.isLoading,
              onPressed: () {
                ref.read(authNotifierProvider.notifier).signInWithGoogle();
              },
            ),
            const SizedBox(height: AppSpacing.md),
            GradientButton(
              label: 'Skip for now',
              isFullWidth: true,
              size: AppButtonSize.large,
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      final currentAuth = ref.read(authNotifierProvider);
                      if (currentAuth.status == AuthStatus.unauthenticated) {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .signInAnonymously();
                      }
                      onComplete();
                    },
            ),
            const SizedBox(height: AppSpacing.lg),
            GestureDetector(
              onTap: onSignIn,
              child: RichText(
                text: TextSpan(
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Click here',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
