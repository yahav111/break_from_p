import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../../shared/widgets/star_field.dart';
import 'widgets/plan_card.dart';

/// Subscription paywall screen.
/// Showcases the gradient CTA button and plan selection cards.
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  /// 0 = monthly, 1 = yearly
  int _selectedPlan = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackground(),
        const StarField(density: 80),
        _buildContent(),
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
          colors: [Color(0xFF1A0A40), Color(0xFF0A0D2E), Color(0xFF0A0D2E)],
          stops: [0, 0.5, 1],
        ),
      ),
    );
  }

  // ── Content ──────────────────────────────────────────────────

  Widget _buildContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),
            _buildLogo(),
            const SizedBox(height: AppSpacing.xl),
            _buildHeadline(),
            const SizedBox(height: AppSpacing.lg),
            _buildSubtitle(),
            const SizedBox(height: AppSpacing.xxl),
            _buildPlanCards(),
            const Spacer(),
            _buildCta(),
            const SizedBox(height: AppSpacing.md),
            _buildFooterNote(),
            const SizedBox(height: AppSpacing.xxxxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Text(
      'QUITTR',
      style: AppTypography.displayLarge.copyWith(
        color: Colors.white,
        letterSpacing: 4,
      ),
    );
  }

  Widget _buildHeadline() {
    return Text(
      'Goodbye Porn,\nHello QUITTR.',
      textAlign: TextAlign.center,
      style: AppTypography.displayLarge.copyWith(
        color: Colors.white,
        fontSize: 36,
        height: 1.15,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Get unlimited access to QUITTR including:\nPersonalised Plan · Content Blocker · Community\nStreak Tracking · Daily Pledges + much more!',
      textAlign: TextAlign.center,
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.darkTextSecondary,
        height: 1.6,
      ),
    );
  }

  Widget _buildPlanCards() {
    return Row(
      children: [
        Expanded(
          child: PlanCard(
            label: 'Monthly',
            price: '₪32/mo',
            isSelected: _selectedPlan == 0,
            onTap: () => setState(() => _selectedPlan = 0),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: PlanCard(
            label: 'Yearly',
            price: '₪8.32/mo',
            badge: 'BEST VALUE',
            isSelected: _selectedPlan == 1,
            onTap: () => setState(() => _selectedPlan = 1),
          ),
        ),
      ],
    );
  }

  Widget _buildCta() {
    return GradientButton(
      label: 'CONTINUE',
      isFullWidth: true,
      size: AppButtonSize.large,
      onPressed: () {},
    );
  }

  Widget _buildFooterNote() {
    return Text(
      'Just 99.90₪ per year  ·  Discrete Purchase  ·  Finally Quit Porn',
      textAlign: TextAlign.center,
      style: AppTypography.caption.copyWith(
        color: AppColors.darkTextSecondary,
      ),
    );
  }
}
