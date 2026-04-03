import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// A selectable grid of trigger category chips.
class TriggerSelector extends StatelessWidget {
  const TriggerSelector({
    super.key,
    required this.selectedTrigger,
    required this.onTriggerSelected,
  });

  /// Currently selected trigger key, or null if none.
  final String? selectedTrigger;

  /// Called when a trigger chip is tapped.
  final ValueChanged<String> onTriggerSelected;

  static const List<_TriggerOption> _triggers = [
    _TriggerOption(key: 'boredom', label: 'Boredom', icon: Icons.hourglass_empty_rounded),
    _TriggerOption(key: 'stress', label: 'Stress', icon: Icons.psychology_rounded),
    _TriggerOption(key: 'loneliness', label: 'Loneliness', icon: Icons.person_off_rounded),
    _TriggerOption(key: 'anxiety', label: 'Anxiety', icon: Icons.warning_amber_rounded),
    _TriggerOption(key: 'habit', label: 'Habit', icon: Icons.repeat_rounded),
    _TriggerOption(key: 'social_media', label: 'Social Media', icon: Icons.phone_android_rounded),
    _TriggerOption(key: 'late_night', label: 'Late Night', icon: Icons.nightlight_rounded),
    _TriggerOption(key: 'other', label: 'Other', icon: Icons.more_horiz_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: _triggers.map((trigger) {
        final isSelected = selectedTrigger == trigger.key;
        return _buildChip(trigger, isSelected);
      }).toList(),
    );
  }

  Widget _buildChip(_TriggerOption trigger, bool isSelected) {
    return GestureDetector(
      onTap: () => onTriggerSelected(trigger.key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.darkCard,
          borderRadius: AppRadius.borderPill,
          border: isSelected
              ? null
              : Border.all(color: AppColors.darkBorderSubtle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              trigger.icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.darkTextSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              trigger.label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.darkTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TriggerOption {
  const _TriggerOption({
    required this.key,
    required this.label,
    required this.icon,
  });

  final String key;
  final String label;
  final IconData icon;
}
