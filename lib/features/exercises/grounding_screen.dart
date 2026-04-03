import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/exercise_provider.dart';
import '../../design_system/design_system.dart';
import 'widgets/exercise_completion_card.dart';
import 'widgets/exercise_step_indicator.dart';

/// 5-4-3-2-1 sensory grounding technique. Interactive stepped flow.
class GroundingScreen extends ConsumerStatefulWidget {
  const GroundingScreen({super.key});

  @override
  ConsumerState<GroundingScreen> createState() => _GroundingScreenState();
}

class _GroundingScreenState extends ConsumerState<GroundingScreen> {
  static const _steps = [
    _GroundingStep(
      text: 'Name 5 things\nyou can SEE',
      icon: Icons.visibility_rounded,
      color: AppColors.primary,
      count: 5,
    ),
    _GroundingStep(
      text: 'Name 4 things\nyou can TOUCH',
      icon: Icons.touch_app_rounded,
      color: AppColors.secondary,
      count: 4,
    ),
    _GroundingStep(
      text: 'Name 3 things\nyou can HEAR',
      icon: Icons.hearing_rounded,
      color: AppColors.tertiary,
      count: 3,
    ),
    _GroundingStep(
      text: 'Name 2 things\nyou can SMELL',
      icon: Icons.air_rounded,
      color: AppColors.info,
      count: 2,
    ),
    _GroundingStep(
      text: 'Name 1 thing\nyou can TASTE',
      icon: Icons.restaurant_rounded,
      color: AppColors.primary,
      count: 1,
    ),
  ];

  int _currentStep = 0;
  bool _isComplete = false;
  DateTime? _startTime;

  void _advance() {
    _startTime ??= DateTime.now();

    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _complete();
    }
  }

  void _complete() {
    final duration = DateTime.now().difference(_startTime!).inSeconds;
    ref.read(exerciseNotifierProvider.notifier).recordCompletion(
          exerciseType: 'grounding',
          durationSeconds: duration,
        );
    setState(() => _isComplete = true);
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
                    : _buildExercise(),
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
            'Grounding',
            style: AppTypography.headlineSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildExercise() {
    final step = _steps[_currentStep];

    return GestureDetector(
      onTap: _advance,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          const Spacer(),
          // Large icon.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Icon(
              step.icon,
              key: ValueKey('icon_$_currentStep'),
              color: step.color,
              size: 64,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Count number.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              '${step.count}',
              key: ValueKey('count_$_currentStep'),
              style: AppTypography.displayLarge.copyWith(
                color: step.color,
                fontWeight: AppTypography.bold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Step text.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              step.text,
              key: ValueKey('text_$_currentStep'),
              textAlign: TextAlign.center,
              style: AppTypography.headlineMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Instruction.
          Text(
            'Take a moment, then tap to continue',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          // Step indicator.
          ExerciseStepIndicator(
            totalSteps: _steps.length,
            currentStep: _currentStep,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildCompletion() {
    final duration = DateTime.now().difference(_startTime!).inSeconds;

    return ExerciseCompletionCard(
      exerciseType: 'grounding',
      durationSeconds: duration,
      onDone: () => context.pop(),
    );
  }
}

class _GroundingStep {
  const _GroundingStep({
    required this.text,
    required this.icon,
    required this.color,
    required this.count,
  });

  final String text;
  final IconData icon;
  final Color color;
  final int count;
}
