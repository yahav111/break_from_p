import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Square card used on the Library screen for each category
/// (Mood, Meditate, Lifetree, Soundscapes).
/// Displays a full-bleed background image with a gradient overlay
/// and title/subtitle at the bottom.
class LibraryCategoryCard extends StatelessWidget {
  const LibraryCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String imagePath;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: AppRadius.borderLarge,
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),

            // Gradient overlay — darker at bottom for text readability
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),

            // Text content at bottom
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
