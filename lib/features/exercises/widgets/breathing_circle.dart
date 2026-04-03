import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Animated circular widget that scales with breathing phases.
///
/// Scale mapping based on [animation] value:
/// - 0.0 - 0.33: Inhale (scale 0.6 -> 1.0)
/// - 0.33 - 0.66: Hold (scale 1.0)
/// - 0.66 - 1.0: Exhale (scale 1.0 -> 0.6)
class BreathingCircle extends StatelessWidget {
  const BreathingCircle({super.key, required this.animation});

  final Animation<double> animation;

  double _computeScale(double value) {
    if (value <= 0.33) {
      // Inhale: scale from 0.6 to 1.0.
      final t = value / 0.33;
      return 0.6 + (0.4 * t);
    } else if (value <= 0.66) {
      // Hold: stay at 1.0.
      return 1.0;
    } else {
      // Exhale: scale from 1.0 to 0.6.
      final t = (value - 0.66) / 0.34;
      return 1.0 - (0.4 * t);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final scale = _computeScale(animation.value);

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gradientStart,
                  AppColors.gradientEnd,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 40,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
