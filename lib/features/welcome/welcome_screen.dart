import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design_system/design_system.dart';
import '../../routing/route_names.dart';
import '../../shared/widgets/star_field.dart';

/// The first screen a new user sees.
/// Shows the app name, a one-liner value prop and entry CTAs.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackground(),
        const StarField(density: 50),
        _buildHorizonGlow(),
        _buildContent(context),
      ],
    );
  }

  // ── Background ──────────────────────────────────────────────

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0D2E), Color(0xFF1A1050), Color(0xFF0A0D2E)],
          stops: [0, 0.5, 1],
        ),
      ),
    );
  }

  Widget _buildHorizonGlow() {
    return const Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 280,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0x662B1070)],
          ),
        ),
      ),
    );
  }

  // ── Content ──────────────────────────────────────────────────

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xxxl),
            _buildLogo(),
            const Spacer(),
            _buildHeadline(),
            const SizedBox(height: AppSpacing.xxxl),
            _buildRatingRow(),
            const SizedBox(height: AppSpacing.xl),
            _buildPrimaryButton(context),
            const SizedBox(height: AppSpacing.md),
            _buildSecondaryButton(),
            const SizedBox(height: AppSpacing.xxl),
            _buildLegalText(),
            const SizedBox(height: AppSpacing.xxxxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Text(
        'QUITTR',
        style: AppTypography.displayLarge.copyWith(
          color: Colors.white,
          letterSpacing: 4,
          fontWeight: AppTypography.bold,
        ),
      ),
    );
  }

  Widget _buildHeadline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome!',
          style: AppTypography.headlineLarge.copyWith(
            color: Colors.white,
            fontSize: 38,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          "Let's start by finding out if you have a problem with porn",
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.darkTextSecondary,
            fontSize: 18,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(
          5,
          (_) => const Icon(Icons.star, color: AppColors.warning, size: 22),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '4.9',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return AppButton(
      label: 'Start Quiz',
      isFullWidth: true,
      variant: AppButtonVariant.primary,
      icon: Icons.arrow_forward_rounded,
      iconPosition: AppButtonIconPosition.trailing,
      size: AppButtonSize.large,
      onPressed: () => context.go(Routes.quiz),
    );
  }

  Widget _buildSecondaryButton() {
    return AppButton(
      label: 'Already have an account?',
      isFullWidth: true,
      variant: AppButtonVariant.secondary,
      size: AppButtonSize.large,
      onPressed: () {},
    );
  }

  Widget _buildLegalText() {
    return Center(
      child: Text(
        'By continuing, you agree to our Terms & Conditions\nand Privacy Policy',
        textAlign: TextAlign.center,
        style: AppTypography.caption.copyWith(
          color: AppColors.darkTextTertiary,
        ),
      ),
    );
  }
}
