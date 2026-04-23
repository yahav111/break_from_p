import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// "Well done" overlay shown after an exercise completes.
class ExerciseCompletionCard extends StatelessWidget {
  const ExerciseCompletionCard({
    super.key,
    required this.exerciseType,
    required this.durationSeconds,
    required this.onDone,
  });

  final String exerciseType;
  final int durationSeconds;
  final VoidCallback onDone;

  String get _exerciseLabel {
    switch (exerciseType) {
      case 'breathing':
        return 'נשימה';
      case 'urge_surfing':
        return 'גלישה על דחף';
      case 'grounding':
        return 'הארקה';
      case 'body_scan':
        return 'סריקת גוף';
      default:
        return exerciseType;
    }
  }

  String get _formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          size: 80,
          color: AppColors.secondary,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'כל הכבוד!',
          style: AppTypography.headlineLarge.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '$_exerciseLabel \u00b7 $_formattedDuration',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: GradientButton(
            label: 'סיום',
            onPressed: onDone,
          ),
        ),
      ],
    );
  }
}
