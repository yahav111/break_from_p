import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../infrastructure/auth/auth_provider.dart';
import '../../../../infrastructure/auth/auth_state.dart';
import '../../../../shared/widgets/star_field.dart';
import '../../../auth/widgets/social_sign_in_button.dart';

/// Screen 2: "Become a QUITTR" — social sign-in or skip.
/// Styled to match the AuthScreen ("Welcome back") for a consistent design.
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

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background gradient matching AuthScreen.
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A0A40), Color(0xFF0A0D2E), Color(0xFF0A0D2E)],
              stops: [0, 0.5, 1],
            ),
          ),
        ),
        const StarField(density: 80),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxxxxl),
                Icon(
                  Icons.directions_run_rounded,
                  size: 120,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Text(
                  'הצטרף ל-\nQUITTR',
                  style: AppTypography.displayLarge.copyWith(
                    color: Colors.white,
                    fontSize: 36,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'צור חשבון כדי לשמור את\nההתקדמות שלך בכל המכשירים.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkTextSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxxxl),
                SocialSignInButton(
                  label: 'המשך עם Google',
                  svgAsset: 'assets/icons/google_logo.svg',
                  isLoading: authState.isGoogleLoading,
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          ref
                              .read(authNotifierProvider.notifier)
                              .signInWithGoogle();
                        },
                ),
                if (Platform.isIOS) ...[
                  const SizedBox(height: AppSpacing.md),
                  SocialSignInButton(
                    label: 'המשך עם Apple',
                    svgAsset: 'assets/icons/apple_logo.svg',
                    isLoading: authState.isAppleLoading,
                    onPressed: authState.isLoading
                        ? null
                        : () {
                            ref
                                .read(authNotifierProvider.notifier)
                                .signInWithApple();
                          },
                  ),
                ],
                const SizedBox(height: AppSpacing.xxl),
                GradientButton(
                  label: 'דלג לעת עתה',
                  isFullWidth: true,
                  size: AppButtonSize.large,
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          final currentAuth = ref.read(authNotifierProvider);
                          if (currentAuth.status ==
                              AuthStatus.unauthenticated) {
                            await ref
                                .read(authNotifierProvider.notifier)
                                .signInAnonymously();
                          }
                          onComplete();
                        },
                ),
                const SizedBox(height: AppSpacing.xxl),
                Center(
                  child: GestureDetector(
                    onTap: onSignIn,
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.darkTextSecondary,
                        ),
                        children: [
                          const TextSpan(text: 'כבר יש לך חשבון? '),
                          TextSpan(
                            text: 'התחבר',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: AppTypography.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxxxl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
