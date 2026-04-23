import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design_system/design_system.dart';
import '../../routing/route_names.dart';
import '../../shared/widgets/star_field.dart';
import 'widgets/plan_card.dart';

/// Subscription paywall screen.
/// In Phase 1, tapping "CONTINUE" completes onboarding and goes to Home.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  /// 0 = monthly, 1 = yearly
  int _selectedPlan = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          const StarField(density: 80),
          _buildContent(),
        ],
      ),
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
      'להתראות פורנו,\nשלום QUITTR.',
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
      'קבל גישה בלתי מוגבלת ל-QUITTR כולל:\nתוכנית מותאמת אישית · חסם תוכן · קהילה\nמעקב רצף · התחייבויות יומיות ועוד הרבה!',
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
            label: 'חודשי',
            price: '₪32/חודש',
            isSelected: _selectedPlan == 0,
            onTap: () => setState(() => _selectedPlan = 0),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: PlanCard(
            label: 'שנתי',
            price: '₪8.32/חודש',
            badge: 'הכי משתלם',
            isSelected: _selectedPlan == 1,
            onTap: () => setState(() => _selectedPlan = 1),
          ),
        ),
      ],
    );
  }

  Widget _buildCta() {
    return GradientButton(
      label: 'המשך',
      isFullWidth: true,
      size: AppButtonSize.large,
      onPressed: () => context.go(Routes.auth),
    );
  }

  Widget _buildFooterNote() {
    return Text(
      'רק 99.90₪ לשנה · רכישה דיסקרטית · להפסיק לצמיתות',
      textAlign: TextAlign.center,
      style: AppTypography.caption.copyWith(
        color: AppColors.darkTextSecondary,
      ),
    );
  }
}
