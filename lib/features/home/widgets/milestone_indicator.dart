import 'package:flutter/material.dart';

import '../../../core/services/streak_engine.dart';
import '../../../design_system/design_system.dart';

/// Row of milestone markers positioned along the brain rewire progress bar.
/// Dots are filled/colored when passed, hollow when upcoming.
class MilestoneIndicator extends StatelessWidget {
  const MilestoneIndicator({
    super.key,
    required this.currentDays,
  });

  final int currentDays;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          return Stack(
            clipBehavior: Clip.none,
            children: StreakEngine.milestones.map((milestone) {
              final fraction = (milestone / 90).clamp(0.0, 1.0);
              final left = fraction * totalWidth;
              final reached = currentDays >= milestone;

              return Positioned(
                left: left - 4,
                top: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: reached ? AppColors.primary : Colors.transparent,
                        border: Border.all(
                          color: reached
                              ? AppColors.primary
                              : AppColors.darkTextTertiary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${milestone}d',
                      style: TextStyle(
                        fontSize: 8,
                        color: reached
                            ? AppColors.primary
                            : AppColors.darkTextTertiary,
                        fontWeight:
                            reached ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
