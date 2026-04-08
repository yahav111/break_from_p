import 'package:flutter/material.dart';

import '../../../../../design_system/design_system.dart';

/// Quiz option card with a leading icon (used for the attribution question).
class QuizIconOptionCard extends StatelessWidget {
  const QuizIconOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.overlayWhiteMedium
              : AppColors.overlayWhiteSubtle.withValues(alpha: 0.05),
          borderRadius: AppRadius.borderPill,
          border: Border.all(
            color: isSelected
                ? AppColors.darkBorderSubtle.withValues(alpha: 0.8)
                : AppColors.darkBorderSubtle.withValues(alpha: 0.1),
            width: 1.5,
          ),
          boxShadow: isSelected ? AppShadows.primaryGlow : null,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.darkElevated,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.darkBorderSubtle.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: AppTypography.medium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
