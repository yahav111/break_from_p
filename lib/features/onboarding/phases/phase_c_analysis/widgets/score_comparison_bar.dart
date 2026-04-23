import 'package:flutter/material.dart';

import '../../../../../design_system/design_system.dart';

/// Animated bar chart comparing user's score vs the average.
class ScoreComparisonBar extends StatefulWidget {
  const ScoreComparisonBar({
    super.key,
    required this.userScore,
    required this.averageScore,
  });

  final double userScore;
  final double averageScore;

  @override
  State<ScoreComparisonBar> createState() => _ScoreComparisonBarState();
}

class _ScoreComparisonBarState extends State<ScoreComparisonBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_controller.value);
        return SizedBox(
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(
                label: 'הציון שלך',
                value: widget.userScore,
                animatedValue: widget.userScore * t,
                color: AppColors.error,
                width: 80,
              ),
              const SizedBox(width: AppSpacing.xxxl),
              _buildBar(
                label: 'ממוצע',
                value: widget.averageScore,
                animatedValue: widget.averageScore * t,
                color: AppColors.success,
                width: 80,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBar({
    required String label,
    required double value,
    required double animatedValue,
    required Color color,
    required double width,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${animatedValue.round()}%',
          style: AppTypography.headlineMedium.copyWith(
            color: color,
            fontWeight: AppTypography.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: width,
          height: (animatedValue / 100) * 120,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.medium),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}
