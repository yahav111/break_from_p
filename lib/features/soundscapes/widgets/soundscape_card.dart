import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// A square card representing an individual soundscape.
///
/// Shows the icon, name, and a "Playing" indicator when active.
class SoundscapeCard extends StatelessWidget {
  const SoundscapeCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.isPlaying,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final Color color;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: AppRadius.borderLarge,
          border: Border.all(
            color: isPlaying ? color : AppColors.darkBorderSubtle,
            width: isPlaying ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon bubble
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderMedium,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            if (isPlaying) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                'מתנגן כעת',
                style: AppTypography.caption.copyWith(color: color),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Text(
              name,
              style: AppTypography.titleSmall.copyWith(color: Colors.white),
            ),
            if (isPlaying) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                'מתנגן',
                style: AppTypography.caption.copyWith(color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
