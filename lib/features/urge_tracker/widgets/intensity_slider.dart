import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Custom 1-10 intensity slider with green-to-red color gradient.
class IntensitySlider extends StatelessWidget {
  const IntensitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// Current intensity value (1-10).
  final int value;

  /// Called when the slider value changes.
  final ValueChanged<int> onChanged;

  Color _intensityColor(int v) {
    return Color.lerp(
      AppColors.secondary,
      AppColors.error,
      (v - 1) / 9,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _intensityColor(value);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: activeColor,
            inactiveTrackColor: AppColors.darkCard,
            thumbColor: Colors.white,
            overlayColor: activeColor.withValues(alpha: 0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 12,
            ),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1',
                style: AppTypography.caption.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
              Text(
                '10',
                style: AppTypography.caption.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
