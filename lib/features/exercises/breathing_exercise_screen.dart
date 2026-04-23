import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/breathing_params.dart';
import '../../core/providers/exercise_provider.dart';
import '../../design_system/design_system.dart';
import 'widgets/breathing_circle.dart';
import 'widgets/exercise_completion_card.dart';

/// Animated breathing exercise. Defaults to 4-4-4 box breathing (5 cycles)
/// but accepts optional [BreathingParams] for Lifetree-unlocked patterns.
class BreathingExerciseScreen extends ConsumerStatefulWidget {
  const BreathingExerciseScreen({super.key, this.params});

  /// When non-null, overrides the default 4-4-4 pattern.
  final BreathingParams? params;

  @override
  ConsumerState<BreathingExerciseScreen> createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState
    extends ConsumerState<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  int _currentCycle = 0;
  String _phase = 'שאיפה';
  bool _isStarted = false;
  bool _isComplete = false;
  DateTime? _startTime;

  /// Resolved breathing parameters (custom or default 4-4-4).
  BreathingParams get _bp =>
      widget.params ??
      const BreathingParams(
        inhale: 4,
        hold: 4,
        exhale: 4,
        cycles: 5,
        label: 'נשימת קופסה 4-4-4',
      );

  int get _totalCycles => _bp.cycles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _bp.cycleDuration),
    );
    _controller.addListener(_onTick);
    _controller.addStatusListener(_onStatus);
  }

  void _onTick() {
    final value = _controller.value;
    String newPhase;
    if (value <= _bp.inhaleEnd) {
      newPhase = 'שאיפה';
    } else if (_bp.hold > 0 && value <= _bp.holdEnd) {
      newPhase = 'עצור';
    } else {
      newPhase = 'נשיפה';
    }
    if (newPhase != _phase) {
      setState(() => _phase = newPhase);
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      final next = _currentCycle + 1;
      if (next >= _totalCycles) {
        _complete();
      } else {
        setState(() {
          _currentCycle = next;
          _phase = 'שאיפה';
        });
        _controller.forward(from: 0.0);
      }
    }
  }

  void _start() {
    setState(() {
      _isStarted = true;
      _startTime = DateTime.now();
      _currentCycle = 0;
      _phase = 'שאיפה';
    });
    _controller.forward(from: 0.0);
  }

  void _complete() {
    _controller.stop();
    final duration = DateTime.now().difference(_startTime!).inSeconds;
    ref.read(exerciseNotifierProvider.notifier).recordCompletion(
          exerciseType: 'breathing',
          durationSeconds: duration,
        );
    setState(() => _isComplete = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            children: [
              _buildAppBar(),
              Expanded(
                child: _isComplete
                    ? _buildCompletion()
                    : _isStarted
                        ? _buildExercise()
                        : _buildStart(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
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
          const SizedBox(width: AppSpacing.lg),
          Text(
            'תרגיל נשימה',
            style: AppTypography.headlineSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BreathingCircle(animation: _controller),
        const SizedBox(height: AppSpacing.xxxl),
        Text(
          _bp.label,
          style: AppTypography.headlineMedium.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '$_totalCycles מחזורים \u00b7 כ-${(_totalCycles * _bp.cycleDuration / 60).ceil()} דקות',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xxxxl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: GradientButton(
            label: 'התחל',
            onPressed: _start,
          ),
        ),
      ],
    );
  }

  Widget _buildExercise() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BreathingCircle(animation: _controller),
        const SizedBox(height: AppSpacing.xxxxl),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _phase,
            key: ValueKey(_phase),
            style: AppTypography.headlineMedium.copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'מחזור ${_currentCycle + 1} מתוך $_totalCycles',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletion() {
    final duration = DateTime.now().difference(_startTime!).inSeconds;

    return ExerciseCompletionCard(
      exerciseType: 'breathing',
      durationSeconds: duration,
      onDone: () => context.pop(),
    );
  }
}
