import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Playback controls for the soundscape player.
///
/// Shows play/pause, volume slider, and a sleep timer with selectable chips.
class PlaybackControls extends StatelessWidget {
  const PlaybackControls({
    super.key,
    required this.isPlaying,
    required this.volume,
    this.timerMinutes,
    required this.onPlayPause,
    required this.onVolumeChanged,
    required this.onTimerChanged,
  });

  final bool isPlaying;
  final double volume;
  final int? timerMinutes;
  final VoidCallback onPlayPause;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<int?> onTimerChanged;

  static const _timerOptions = <int?>[null, 5, 10, 15, 30];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderLarge,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play / Pause button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onPlayPause,
                iconSize: 48,
                icon: Icon(
                  isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Volume row
          Row(
            children: [
              Icon(
                Icons.volume_down_rounded,
                color: AppColors.darkTextSecondary,
                size: 20,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.darkTextTertiary,
                    thumbColor: AppColors.primary,
                    overlayColor: AppColors.primary.withValues(alpha: 0.15),
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 7,
                    ),
                  ),
                  child: Slider(
                    value: volume,
                    onChanged: onVolumeChanged,
                  ),
                ),
              ),
              Icon(
                Icons.volume_up_rounded,
                color: AppColors.darkTextSecondary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Timer row
          Row(
            children: [
              Text(
                'Sleep Timer',
                style: AppTypography.caption.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _timerOptions.map((option) {
                      final isSelected = timerMinutes == option;
                      final label = option == null ? 'Off' : '${option}m';
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: GestureDetector(
                          onTap: () => onTimerChanged(option),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: AppRadius.borderPill,
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: AppColors.darkBorderSubtle,
                                    ),
                            ),
                            child: Text(
                              label,
                              style: AppTypography.caption.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.darkTextSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
