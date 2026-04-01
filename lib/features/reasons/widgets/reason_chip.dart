import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// A styled chip displaying a single reason for quitting.
class ReasonChip extends StatelessWidget {
  const ReasonChip({
    super.key,
    required this.text,
    this.onDelete,
  });

  final String text;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderPill,
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: AppColors.darkTextTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
