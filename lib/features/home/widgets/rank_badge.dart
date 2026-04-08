import 'package:flutter/material.dart';

import '../../../core/models/character_stage.dart';
import '../../../core/services/character_engine.dart';
import '../../../design_system/design_system.dart';

/// Pill-shaped badge showing the user's current rank (character stage)
/// with a "Next: X in Y days" sub-label.
class RankBadge extends StatelessWidget {
  const RankBadge({super.key, required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final stage = CharacterEngine.stageForDays(days);
    final stageName = CharacterEngine.stageName(stage);
    final (primary, _) = CharacterEngine.stageColors(stage);

    // Determine next stage info.
    final stageValues = CharacterStage.values;
    final currentIndex = stageValues.indexOf(stage);
    final isMaxRank = currentIndex >= stageValues.length - 1;

    String subLabel;
    if (isMaxRank) {
      subLabel = 'Max Rank';
    } else {
      final nextStage = stageValues[currentIndex + 1];
      final nextName = CharacterEngine.stageName(nextStage);
      final nextMinDays = CharacterEngine.stageMinDays(nextStage);
      final daysUntil = nextMinDays - days;
      subLabel = 'Next: $nextName in $daysUntil ${daysUntil == 1 ? 'day' : 'days'}';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.15),
            borderRadius: AppRadius.borderPill,
            border: Border.all(
              color: primary.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            stageName,
            style: AppTypography.labelMedium.copyWith(
              color: primary,
              fontWeight: AppTypography.semiBold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subLabel,
          style: AppTypography.caption.copyWith(
            color: AppColors.darkTextTertiary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
