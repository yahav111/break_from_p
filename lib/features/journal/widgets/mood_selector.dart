import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Row of 5 mood options for journal entries.
/// Mood mapping: 0=bad, 1=struggling, 2=okay, 3=good, 4=great.
class MoodSelector extends StatelessWidget {
  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  final int? selectedMood;
  final ValueChanged<int> onMoodSelected;

  static const _moods = [
    _MoodOption(0, Icons.sentiment_very_dissatisfied, 'Bad'),
    _MoodOption(1, Icons.sentiment_dissatisfied, 'Struggling'),
    _MoodOption(2, Icons.sentiment_neutral, 'Okay'),
    _MoodOption(3, Icons.sentiment_satisfied, 'Good'),
    _MoodOption(4, Icons.sentiment_very_satisfied, 'Great'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _moods.map((mood) {
        final isSelected = selectedMood == mood.value;
        return GestureDetector(
          onTap: () => onMoodSelected(mood.value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.darkCard,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  mood.icon,
                  color: isSelected
                      ? Colors.white
                      : AppColors.darkTextSecondary,
                  size: 28,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                mood.label,
                style: AppTypography.caption.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.darkTextSecondary,
                  fontWeight: isSelected
                      ? AppTypography.semiBold
                      : AppTypography.regular,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MoodOption {
  const _MoodOption(this.value, this.icon, this.label);

  final int value;
  final IconData icon;
  final String label;
}
