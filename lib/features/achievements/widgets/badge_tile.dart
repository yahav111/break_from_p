import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/services/achievement_engine.dart';
import '../../../design_system/design_system.dart';

/// A single badge tile in the achievements grid.
///
/// Shows the achievement icon, title, and unlock status.
/// Tapping opens an [AppBottomDialog] with the full description.
class BadgeTile extends StatelessWidget {
  const BadgeTile({
    super.key,
    required this.def,
    required this.isUnlocked,
    this.unlockedAt,
  });

  final AchievementDef def;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  @override
  Widget build(BuildContext context) {
    final categoryColor = AchievementEngine.categoryColor(def.category);

    return GestureDetector(
      onTap: () => _showDetail(context, categoryColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconCircle(categoryColor),
          const SizedBox(height: AppSpacing.sm),
          Text(
            def.title,
            style: AppTypography.caption.copyWith(
              color: isUnlocked ? Colors.white : AppColors.darkTextTertiary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            isUnlocked ? _formatDate(unlockedAt!) : 'נעול',
            style: AppTypography.caption.copyWith(
              fontSize: 9,
              color: isUnlocked
                  ? AppColors.darkTextSecondary
                  : AppColors.darkTextTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIconCircle(Color categoryColor) {
    if (isUnlocked) {
      return Container(
        width: 56,
        height: 56,
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
          size: 24,
        ),
      );
    }

    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.darkCard,
            border: Border.all(
              color: AppColors.darkBorderSubtle,
              width: 1.5,
            ),
          ),
          child: Icon(
            def.icon,
            color: AppColors.darkTextTertiary,
            size: 24,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkSurface,
            ),
            child: const Icon(
              Icons.lock_rounded,
              color: AppColors.darkTextTertiary,
              size: 10,
            ),
          ),
        ),
      ],
    );
  }

  void _showDetail(BuildContext context, Color categoryColor) {
    String message = def.description;
    if (isUnlocked && unlockedAt != null) {
      message += '\n\nנפתח בתאריך ${_formatDate(unlockedAt!)}';
    }

    AppBottomDialog.show(
      context: context,
      title: def.title,
      message: message,
      primaryButtonLabel: 'אישור',
      onPrimaryPressed: () {},
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('d בMMMM y', 'he_IL').format(date);
  }
}
