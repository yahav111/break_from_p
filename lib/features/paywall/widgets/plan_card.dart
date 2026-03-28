import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// A subscription plan selection card for the paywall.
class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.label,
    required this.price,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  final String label;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  /// Optional badge text shown above the title (e.g. 'BEST VALUE').
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.darkCard,
          borderRadius: AppRadius.borderLarge,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.darkBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppShadows.primaryGlow : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null) ...[
              _buildBadge(),
              const SizedBox(height: AppSpacing.sm),
            ],
            Text(
              label,
              style: AppTypography.titleSmall.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              price,
              style: AppTypography.headlineSmall.copyWith(
                color: isSelected
                    ? AppColors.primaryLight
                    : AppColors.darkTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: AppRadius.borderPill,
      ),
      child: Text(
        badge!,
        style: AppTypography.labelSmall.copyWith(color: Colors.white),
      ),
    );
  }
}
