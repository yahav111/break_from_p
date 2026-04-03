import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Reusable step/progress indicator dots.
class ExerciseStepIndicator extends StatelessWidget {
  const ExerciseStepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.activeColor = AppColors.primary,
  });

  final int totalSteps;
  final int currentStep;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;

        return Padding(
          padding: EdgeInsets.only(
            right: index < totalSteps - 1 ? AppSpacing.sm : 0,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isActive ? 10 : 8,
            height: isActive ? 10 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? activeColor
                  : AppColors.darkTextTertiary.withValues(alpha: 0.3),
            ),
          ),
        );
      }),
    );
  }
}
