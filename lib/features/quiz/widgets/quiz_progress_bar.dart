import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// A reusable progress bar specifically tailored for the quiz flow.
/// Features a dark track and a gradient fill pill.
class QuizProgressBar extends StatelessWidget {
  const QuizProgressBar({
    super.key,
    required this.progress,
  });

  /// The progress value between 0.0 and 1.0.
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.darkElevated, // Dark track
        borderRadius: AppRadius.borderPill,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: AlignmentDirectional.centerStart,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: constraints.maxWidth * progress.clamp(0.0, 1.0),
              height: 8,
              decoration: BoxDecoration(
                // The gradient is cyan to purple as seen in the design
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF00E5FF), // Cyan/light blue
                    Color(0xFF7B61FF), // Purple
                  ],
                ),
                borderRadius: AppRadius.borderPill,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
