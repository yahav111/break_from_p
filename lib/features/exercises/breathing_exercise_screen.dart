import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/exercise_provider.dart';
import '../../design_system/design_system.dart';
import 'widgets/breathing_circle.dart';
import 'widgets/exercise_completion_card.dart';

/// Animated breathing exercise: 4s inhale, 4s hold, 4s exhale (5 cycles).
class BreathingExerciseScreen extends ConsumerStatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  ConsumerState<BreathingExerciseScreen> createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState
    extends ConsumerState<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  int _currentCycle = 0;
  final int _totalCycles = 5;
  String _phase = 'Breathe In';
  bool _isStarted = false;
  bool _isComplete = false;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    _controller.addListener(_onTick);
    _controller.addStatusListener(_onStatus);
  }

  void _onTick() {
    final value = _controller.value;
    String newPhase;
    if (value <= 0.33) {
      newPhase = 'Breathe In';
    } else if (value <= 0.66) {
      newPhase = 'Hold';
    } else {
      newPhase = 'Breathe Out';
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
          _phase = 'Breathe In';
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
      _phase = 'Breathe In';
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
            'Breathing Exercise',
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
          '4-4-4 Box Breathing',
          style: AppTypography.headlineMedium.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '5 cycles \u00b7 ~1 minute',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xxxxl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: GradientButton(
            label: 'Begin',
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
          'Cycle ${_currentCycle + 1} of $_totalCycles',
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
