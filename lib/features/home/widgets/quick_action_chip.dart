import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// A pill-shaped quick-action button used in the Home screen grid.
class QuickActionChip extends StatelessWidget {
  const QuickActionChip({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: AppRadius.borderPill,
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.darkTextSecondary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
