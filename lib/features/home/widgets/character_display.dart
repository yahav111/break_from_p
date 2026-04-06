import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/character_stage.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../../core/services/character_engine.dart';
import '../../../design_system/design_system.dart';
import 'characters/character_painter_factory.dart';

/// Displays the character evolution avatar based on streak days.
///
/// Shows an animated CustomPainter that evolves through 7 stages.
/// When the stage changes, plays a transition animation (scale down
/// + white flash, then scale up the new character).
class CharacterDisplay extends ConsumerStatefulWidget {
  const CharacterDisplay({required this.days, super.key});

  /// Current streak day count.
  final int days;

  @override
  ConsumerState<CharacterDisplay> createState() => _CharacterDisplayState();
}

class _CharacterDisplayState extends ConsumerState<CharacterDisplay>
    with TickerProviderStateMixin {
  /// Idle breathing / pulse animation (repeating).
  late final AnimationController _idleController;

  /// One-shot evolution transition animation.
  late final AnimationController _evolutionController;

  /// The stage currently being rendered.
  late CharacterStage _currentStage;

  /// The stage we are transitioning away from (during evolution).
  CharacterStage? _previousStage;

  /// Whether an evolution animation is in progress.
  bool _isEvolving = false;

  @override
  void initState() {
    super.initState();

    _currentStage = CharacterEngine.stageForDays(widget.days);

    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _evolutionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addStatusListener(_onEvolutionStatus);

    // Check if we need to evolve on first build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForEvolution();
    });
  }

  @override
  void didUpdateWidget(CharacterDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.days != widget.days) {
      _checkForEvolution();
    }
  }

  void _checkForEvolution() {
    final newStage = CharacterEngine.stageForDays(widget.days);
    if (newStage == _currentStage && !_isEvolving) return;
    if (newStage == _currentStage) return;

    final appState = ref.read(appStateNotifierProvider);
    final lastShown = appState.lastShownCharacterStage;

    // Only animate if the stage is different from what was last acknowledged.
    if (lastShown != newStage.name) {
      _previousStage = _currentStage;
      _currentStage = newStage;
      _isEvolving = true;
      _evolutionController.forward(from: 0);
    } else {
      // Stage was already acknowledged, just update silently.
      setState(() {
        _currentStage = newStage;
      });
    }
  }

  void _onEvolutionStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _isEvolving = false;
      _previousStage = null;
      // Persist that the user has seen this stage.
      ref
          .read(appStateNotifierProvider.notifier)
          .updateCharacterStage(_currentStage.name);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _evolutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch appState so we re-check when it changes externally.
    ref.watch(appStateNotifierProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: _isEvolving
              ? _buildEvolutionTransition()
              : _buildIdleCharacter(),
        ),
        const SizedBox(height: 6),
        _buildStageName(),
      ],
    );
  }

  Widget _buildIdleCharacter() {
    return AnimatedBuilder(
      animation: _idleController,
      builder: (context, _) {
        return CustomPaint(
          painter: characterPainterFor(
            _currentStage,
            _idleController.value,
          ),
          size: const Size(120, 120),
        );
      },
    );
  }

  Widget _buildEvolutionTransition() {
    return AnimatedBuilder(
      animation: Listenable.merge([_idleController, _evolutionController]),
      builder: (context, _) {
        final ev = _evolutionController.value;

        // Phase 1 (0 - 0.33): old character scales down + fades to white
        // Phase 2 (0.33 - 0.5): white flash
        // Phase 3 (0.5 - 1.0): new character scales up + fades in
        if (ev <= 0.5) {
          // Shrink old character and overlay white glow
          final phaseProgress = (ev / 0.5).clamp(0.0, 1.0);
          final scale = 1.0 - phaseProgress * 0.4;
          final whiteOpacity = phaseProgress;
          final stage = _previousStage ?? _currentStage;

          return Transform.scale(
            scale: scale,
            child: Stack(
              children: [
                CustomPaint(
                  painter: characterPainterFor(
                    stage,
                    _idleController.value,
                  ),
                  size: const Size(120, 120),
                ),
                // White flash overlay
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: whiteOpacity * 0.8),
                            Colors.white.withValues(alpha: whiteOpacity * 0.3),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // Grow new character
          final phaseProgress = ((ev - 0.5) / 0.5).clamp(0.0, 1.0);
          // Bounce scale: starts at 0.6, overshoots to 1.05, settles at 1.0
          final scale = _bounceScale(phaseProgress);
          final opacity = phaseProgress;

          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: CustomPaint(
                painter: characterPainterFor(
                  _currentStage,
                  _idleController.value,
                ),
                size: const Size(120, 120),
              ),
            ),
          );
        }
      },
    );
  }

  /// Produces a bounce scale curve: 0.6 -> 1.08 -> 1.0
  double _bounceScale(double t) {
    if (t < 0.7) {
      // Rise from 0.6 to 1.08
      return 0.6 + (1.08 - 0.6) * (t / 0.7);
    } else {
      // Settle from 1.08 to 1.0
      final settleT = (t - 0.7) / 0.3;
      return 1.08 - 0.08 * settleT;
    }
  }

  Widget _buildStageName() {
    final name = CharacterEngine.stageName(_currentStage);
    final (primary, _) = CharacterEngine.stageColors(_currentStage);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Text(
        name,
        key: ValueKey(name),
        style: AppTypography.caption.copyWith(
          color: _isEvolving ? Colors.white : AppColors.darkTextSecondary,
          fontWeight: _isEvolving ? FontWeight.w600 : FontWeight.w400,
          shadows: _isEvolving
              ? [
                  Shadow(color: primary.withValues(alpha: 0.6), blurRadius: 8),
                ]
              : null,
        ),
      ),
    );
  }
}
