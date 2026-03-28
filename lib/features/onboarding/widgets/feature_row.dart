import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// A single feature highlight row shown on the onboarding screen.
class FeatureRow extends StatelessWidget {
  const FeatureRow({
    super.key,
    required this.icon,
    required this.bubbleColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color bubbleColor;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.overlayWhiteSubtle,
        borderRadius: AppRadius.borderLarge,
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Row(
        children: [
          _buildIconBubble(),
          const SizedBox(width: AppSpacing.lg),
          _buildText(),
        ],
      ),
    );
  }

  Widget _buildIconBubble() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: AppRadius.borderMedium,
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  Widget _buildText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleSmall.copyWith(color: Colors.white),
        ),
        Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}
