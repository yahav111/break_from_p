import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/notification_service.dart';
import '../../design_system/design_system.dart';
import '../../routing/route_names.dart';
import '../../shared/widgets/star_field.dart';
import 'widgets/feature_row.dart';

/// Step-based onboarding screen – requests notification permission.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackground(),
        const StarField(density: 60),
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
          colors: [Color(0xFF080B25), Color(0xFF0A0D2E)],
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
            const SizedBox(height: AppSpacing.xl),
            _buildBackButton(context),
            const SizedBox(height: AppSpacing.xxxl),
            _buildHeadline(),
            const Spacer(),
            _buildFeatureList(),
            const SizedBox(height: AppSpacing.xxxl),
            _buildPrimaryButton(context),
            const SizedBox(height: AppSpacing.md),
            _buildSkipButton(context),
            const SizedBox(height: AppSpacing.xxxxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(Routes.quiz),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.overlayWhiteSubtle,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildHeadline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stay on track\nwith reminders',
          style: AppTypography.headlineLarge.copyWith(
            color: Colors.white,
            fontSize: 34,
            height: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Get gentle reminders and motivation so you never lose sight of your goals.',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.darkTextSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: const [
        FeatureRow(
          icon: Icons.notifications_rounded,
          bubbleColor: AppColors.iconBubblePurple,
          iconColor: AppColors.primary,
          title: 'Smart Reminders',
          subtitle: 'Personalized to your schedule',
        ),
        SizedBox(height: AppSpacing.md),
        FeatureRow(
          icon: Icons.psychology_rounded,
          bubbleColor: AppColors.iconBubbleGreen,
          iconColor: AppColors.secondary,
          title: 'Motivational Insights',
          subtitle: 'Science-based encouragement',
        ),
        SizedBox(height: AppSpacing.md),
        FeatureRow(
          icon: Icons.local_fire_department_rounded,
          bubbleColor: AppColors.iconBubbleOrange,
          iconColor: AppColors.tertiary,
          title: 'Streak Tracking',
          subtitle: 'Watch your progress grow',
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return AppButton(
      label: 'Enable Notifications',
      isFullWidth: true,
      variant: AppButtonVariant.primary,
      size: AppButtonSize.large,
      onPressed: () async {
        final service = NotificationService();
        await service.requestPermission();
        if (context.mounted) {
          context.go(Routes.paywall);
        }
      },
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return AppButton(
      label: 'Not now',
      isFullWidth: true,
      variant: AppButtonVariant.ghost,
      size: AppButtonSize.medium,
      onPressed: () => context.go(Routes.paywall),
    );
  }
}
