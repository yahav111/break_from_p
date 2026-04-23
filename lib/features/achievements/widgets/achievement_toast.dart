import 'package:flutter/material.dart';

import '../../../core/services/achievement_engine.dart';
import '../../../design_system/design_system.dart';

/// Utility to show achievement unlock notifications as a top-positioned SnackBar.
class AchievementToast {
  AchievementToast._();

  /// Shows a floating SnackBar near the top of the screen announcing
  /// that an achievement has been unlocked.
  static void show(BuildContext context, AchievementDef def) {
    final categoryColor = AchievementEngine.categoryColor(def.category);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    categoryColor,
                    categoryColor.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Icon(
                def.icon,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'הישג נפתח',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    def.title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.darkCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLarge),
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
        ),
      ),
    );
  }
}
