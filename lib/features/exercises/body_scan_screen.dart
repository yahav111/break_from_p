import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/exercise_provider.dart';
import '../../design_system/design_system.dart';
import 'widgets/exercise_completion_card.dart';

/// Guided body scan meditation with 10 timed steps (~190 seconds total).
class BodyScanScreen extends ConsumerStatefulWidget {
  const BodyScanScreen({super.key});

  @override
  ConsumerState<BodyScanScreen> createState() => _BodyScanScreenState();
}

class _BodyScanScreenState extends ConsumerState<BodyScanScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isStarted = false;
  bool _isComplete = false;
  DateTime? _startTime;
  int _currentStep = 0;

  static const _steps = <_BodyScanStep>[
    _BodyScanStep('עצום עיניים וקח שלוש נשימות עמוקות', 15),
    _BodyScanStep('התמקד בראש שלך. שים לב למתח.', 20),
    _BodyScanStep('העבר את תשומת הלב לפנים ולסת. הרפה.', 20),
    _BodyScanStep('הרגש את הצוואר והכתפיים. תן להם להתרכך.', 20),
    _BodyScanStep('סרוק מטה דרך הזרועות עד קצות האצבעות.', 20),
    _BodyScanStep('שים לב לחזה שלך עולה ויורד.', 20),
    _BodyScanStep('הרגש את הבטן והגב התחתון.', 20),
    _BodyScanStep('עבור דרך הירכיים, הרגליים, עד כפות הרגליים.', 20),
    _BodyScanStep('עכשיו הרגש את כל הגוף בבת אחת. נשום.', 25),
    _BodyScanStep('פקח בעדינות את העיניים כשאתה מוכן.', 10),
  ];

  /// Total duration in seconds across all steps.
  static final _totalDuration =
      _steps.fold<int>(0, (sum, s) => sum + s.durationSeconds);

  /// Cumulative end-times (in seconds) for each step.
  static final _cumulativeEnds = () {
    var cumulative = 0;
    return _steps.map((s) {
      cumulative += s.durationSeconds;
      return cumulative;
    }).toList();
  }();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _totalDuration),
    );
    _controller.addListener(_onTick);
    _controller.addStatusListener(_onStatus);
  }

  void _onTick() {
    final elapsed = _controller.value * _totalDuration;
    var step = 0;
    for (var i = 0; i < _cumulativeEnds.length; i++) {
      if (elapsed < _cumulativeEnds[i]) {
        step = i;
        break;
      }
    }
    if (step != _currentStep) {
      setState(() => _currentStep = step);
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
          exerciseType: 'body_scan',
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
            'סריקת גוף',
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
        _buildBodyIcon(0.0),
        const SizedBox(height: AppSpacing.xxxl),
        Text(
          'מדיטציית סריקת גוף',
          style: AppTypography.headlineMedium.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '10 שלבים \u00b7 כ-3 דקות',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: Text(
            'סריקה מודרכת דרך הגוף לבניית מודעות '
            'לתחושות גופניות ולשחרור מתח.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.darkTextTertiary,
            ),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = _controller.value;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBodyIcon(progress),
            const SizedBox(height: AppSpacing.xxxxl),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Padding(
                key: ValueKey(_currentStep),
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
                child: Text(
                  _steps[_currentStep].text,
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineMedium.copyWith(
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'שלב ${_currentStep + 1} מתוך ${_steps.length}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Circular progress indicator with a body icon in the center.
  Widget _buildBodyIcon(double progress) {
    const size = 160.0;
    const strokeWidth = 4.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring.
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              valueColor:
                  AlwaysStoppedAnimation(Colors.white.withAlpha(20)),
            ),
          ),
          // Progress ring.
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.primary),
              strokeCap: StrokeCap.round,
            ),
          ),
          // Body icon.
          Container(
            width: size - 24,
            height: size - 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gradientStart.withAlpha(51), // 0.2
                  AppColors.gradientEnd.withAlpha(51),
                ],
              ),
            ),
            child: Icon(
              Icons.self_improvement_rounded,
              size: 56,
              color: Colors.white.withAlpha(204), // 0.8
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletion() {
    final duration = DateTime.now().difference(_startTime!).inSeconds;

    return ExerciseCompletionCard(
      exerciseType: 'body_scan',
      durationSeconds: duration,
      onDone: () => context.pop(),
    );
  }
}

class _BodyScanStep {
  const _BodyScanStep(this.text, this.durationSeconds);

  final String text;
  final int durationSeconds;
}
