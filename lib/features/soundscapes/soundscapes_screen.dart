import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/soundscape_provider.dart';
import '../../design_system/design_system.dart';
import 'widgets/soundscape_card.dart';
import 'widgets/playback_controls.dart';

/// Full-screen soundscape player pushed from the Library "Soundscapes" card.
class SoundscapesScreen extends ConsumerWidget {
  const SoundscapesScreen({super.key});

  // Soundscape definitions.
  static const _soundscapes = [
    _SoundscapeDef(
      name: 'מדורה',
      icon: Icons.local_fire_department_rounded,
      asset: 'assets/audio/campfire.mp3',
      color: AppColors.tertiary,
    ),
    _SoundscapeDef(
      name: 'אוקיינוס',
      icon: Icons.waves_rounded,
      asset: 'assets/audio/ocean.mp3',
      color: AppColors.primary,
    ),
    _SoundscapeDef(
      name: 'גשם',
      icon: Icons.water_drop_rounded,
      asset: 'assets/audio/rain.mp3',
      color: AppColors.info,
    ),
    _SoundscapeDef(
      name: 'יער',
      icon: Icons.park_rounded,
      asset: 'assets/audio/forest.mp3',
      color: AppColors.secondary,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundState = ref.watch(soundscapeNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0D2E), Color(0xFF080B22)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── App bar ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.lg,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.overlayWhiteSubtle,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'נופים קוליים',
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Subtitle ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  'צלילי רקע להרפיה',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Soundscape grid ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _soundscapes.map((def) {
                    final isActive =
                        soundState.currentSoundscape == def.asset;
                    return SoundscapeCard(
                      name: def.name,
                      icon: def.icon,
                      color: def.color,
                      isPlaying: isActive && soundState.isPlaying,
                      onTap: () => ref
                          .read(soundscapeNotifierProvider.notifier)
                          .play(def.asset),
                    );
                  }).toList(),
                ),
              ),

              const Spacer(),

              // ── Playback controls (visible when a sound is loaded) ──
              if (soundState.currentSoundscape != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: PlaybackControls(
                    isPlaying: soundState.isPlaying,
                    volume: soundState.volume,
                    timerMinutes: soundState.timerMinutes,
                    onPlayPause: () => ref
                        .read(soundscapeNotifierProvider.notifier)
                        .togglePlayPause(),
                    onVolumeChanged: (v) => ref
                        .read(soundscapeNotifierProvider.notifier)
                        .setVolume(v),
                    onTimerChanged: (m) => ref
                        .read(soundscapeNotifierProvider.notifier)
                        .setTimer(m),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Internal data class for soundscape definitions.
class _SoundscapeDef {
  const _SoundscapeDef({
    required this.name,
    required this.icon,
    required this.asset,
    required this.color,
  });

  final String name;
  final IconData icon;
  final String asset;
  final Color color;
}
