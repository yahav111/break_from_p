import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Pre-built list of suggested reasons for quitting.
class SuggestedReasons extends StatelessWidget {
  const SuggestedReasons({
    super.key,
    required this.onSelected,
    this.alreadyAdded = const [],
  });

  final void Function(String reason) onSelected;
  final List<String> alreadyAdded;

  static const suggestions = [
    'Improve relationships',
    'Better mental health',
    'More self-discipline',
    'Increased energy',
    'Better focus',
    'Respect my partner',
    'Be a better person',
    'Improve intimacy',
    'Boost confidence',
    'Reclaim my time',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: suggestions.map((reason) {
        final isAdded = alreadyAdded.contains(reason);
        return GestureDetector(
          onTap: isAdded ? null : () => onSelected(reason),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isAdded
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.darkElevated,
              borderRadius: AppRadius.borderPill,
              border: Border.all(
                color: isAdded ? AppColors.primary : AppColors.darkBorderSubtle,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isAdded)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ),
                Text(
                  reason,
                  style: AppTypography.bodySmall.copyWith(
                    color: isAdded ? AppColors.primary : AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
