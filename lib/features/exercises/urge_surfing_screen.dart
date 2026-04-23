import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/exercise_provider.dart';
import '../../design_system/design_system.dart';
import 'widgets/exercise_completion_card.dart';
import 'widgets/exercise_step_indicator.dart';

/// Timed guided urge surfing exercise with 6 step-by-step prompts.
class UrgeSurfingScreen extends ConsumerStatefulWidget {
  const UrgeSurfingScreen({super.key});

  @override
  ConsumerState<UrgeSurfingScreen> createState() => _UrgeSurfingScreenState();
}

class _UrgeSurfingScreenState extends ConsumerState<UrgeSurfingScreen>
    with SingleTickerProviderStateMixin {
  static const _steps = [
    'שים לב לדחף.\nאיפה אתה מרגיש אותו בגוף?',
    'הבחן בתחושה\nללא שיפוט.',
    'דמיין את הדחף כגל.\nהוא עולה, מגיע לשיא, ויורד.',
    'הגל מגיע לשיא.\nהישאר איתו.',
    'הרגש אותו נסוג.\nאתה עדיין כאן.',
    'הדחף חלף.\nאתה בשליטה.',
  ];

  late final AnimationController _controller;

  int _currentStep = 0;
  bool _isStarted = false;
  bool _isComplete = false;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 180),
    );
    _controller.addListener(_onTick);
    _controller.addStatusListener(_onStatus);
  }

  void _onTick() {
    // Each step is 1/6 of total duration.
    final newStep = (_controller.value * _steps.length).floor();
    final clamped = newStep.clamp(0, _steps.length - 1);
    if (clamped != _currentStep) {
      setState(() => _currentStep = clamped);
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _complete();
    }
  }

  void _start() {
    setState(() {
      _isStarted = true;
      _startTime = DateTime.now();
      _currentStep = 0;
    });
    _controller.forward(from: 0.0);
  }

  void _complete() {
    _controller.stop();
    final duration = DateTime.now().difference(_startTime!).inSeconds;
    ref.read(exerciseNotifierProvider.notifier).recordCompletion(
          exerciseType: 'urge_surfing',
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
            'גלישה על דחף',
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
        Icon(
          Icons.waves_rounded,
          color: AppColors.primary,
          size: 64,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'גלישה על דחף',
          style: AppTypography.headlineMedium.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'גלישה על הגל \u00b7 כ-3 דקות',
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
      children: [
        const Spacer(),
        // Animated step text.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: Text(
              _steps[_currentStep],
              key: ValueKey(_currentStep),
              textAlign: TextAlign.center,
              style:
                  AppTypography.headlineSmall.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),

        // Step indicator dots.
        ExerciseStepIndicator(
          totalSteps: _steps.length,
          currentStep: _currentStep,
          activeColor: AppColors.primary,
        ),
        const Spacer(),

        // Linear progress bar.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: AppRadius.borderPill,
                child: LinearProgressIndicator(
                  value: _controller.value,
                  backgroundColor:
                      AppColors.darkTextTertiary.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  minHeight: 6,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xxxxl),
      ],
    );
  }

  Widget _buildCompletion() {
    final duration = DateTime.now().difference(_startTime!).inSeconds;

    return ExerciseCompletionCard(
      exerciseType: 'urge_surfing',
      durationSeconds: duration,
      onDone: () => context.pop(),
    );
  }
}
