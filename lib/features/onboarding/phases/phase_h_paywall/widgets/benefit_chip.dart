import 'package:flutter/material.dart';

import '../../../../../design_system/design_system.dart';

/// Small colored chip displaying a benefit with an emoji.
class BenefitChip extends StatelessWidget {
  const BenefitChip({
    super.key,
    required this.label,
    required this.emoji,
    this.color,
  });

  final String label;
  final String emoji;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.15),
        borderRadius: AppRadius.borderPill,
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.medium,
            ),
          ),
        ],
      ),
    );
  }
}
