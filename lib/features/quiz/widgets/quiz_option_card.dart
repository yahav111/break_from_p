import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// A reusable option card for quiz answers.
/// Handles selected/unselected states.
class QuizOptionCard extends StatelessWidget {
  const QuizOptionCard({
    super.key,
    required this.index,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  /// The numerical index of the option (starts at 1 typically).
  final int index;

  /// The text label ("Yes", "No", etc.).
  final String label;

  /// Whether this option is the active choice.
  final bool isSelected;

  /// Callback when tapped.
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
          boxShadow: isSelected 
              ? AppShadows.primaryGlow 
              : null,
        ),
        child: Row(
          children: [
            _buildLeadingIcon(),
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

  Widget _buildLeadingIcon() {
    if (isSelected) {
      // Show checked circle for selected state
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 20,
        ),
      );
    } else {
      // Show number for unselected state
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF32C5FF), // Light blue from design
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$index',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.darkBackground,
            fontWeight: AppTypography.bold,
          ),
        ),
      );
    }
  }
}
