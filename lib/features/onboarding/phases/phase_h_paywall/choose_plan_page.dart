import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';

/// Final paywall: choose Annual or Lifetime plan.
class ChoosePlanPage extends StatefulWidget {
  const ChoosePlanPage({
    super.key,
    required this.onComplete,
  });

  final VoidCallback onComplete;

  @override
  State<ChoosePlanPage> createState() => _ChoosePlanPageState();
}

class _ChoosePlanPageState extends State<ChoosePlanPage> {
  int _selectedPlan = 0; // 0=Annual, 1=Lifetime

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          children: [
            const Spacer(flex: 2),
            Text(
              'Choose Your Plan',
              style: AppTypography.headlineLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Sale + urgency
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome_rounded,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '60% Off Sale',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTypography.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxl),
                Text(
                  '9 spots remaining',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.error,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxxl),
            // Plan cards
            _buildPlanCard(
              index: 0,
              title: 'Annual',
              price: '\u20AA8.32',
              period: 'per month',
              originalPrice: '\u20AA14.99',
              isSelected: _selectedPlan == 0,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildPlanCard(
              index: 1,
              title: 'Lifetime',
              price: '\u20AA179.90',
              period: 'pay once',
              originalPrice: '\u20AA449.90',
              isSelected: _selectedPlan == 1,
            ),
            const Spacer(flex: 1),
            // CTA
            GradientButton(
              label: 'CONTINUE',
              isFullWidth: true,
              size: AppButtonSize.large,
              onPressed: widget.onComplete,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded,
                    color: AppColors.success, size: 14),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'No commitment, cancel anytime',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String price,
    required String period,
    required String originalPrice,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.darkCard,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.darkBorderSubtle,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppShadows.primaryGlow : null,
        ),
        child: Row(
          children: [
            // Radio circle
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.darkBorderSubtle,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.semiBold,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  originalPrice,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.darkTextTertiary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      price,
                      style: AppTypography.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: AppTypography.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  period,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
