import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/urge_provider.dart';
import '../../design_system/design_system.dart';
import 'widgets/intensity_slider.dart';
import 'widgets/trigger_selector.dart';

/// Full-screen urge logging flow (outside shell, like panic mode).
/// Multi-step: intensity -> trigger -> optional note -> done.
class UrgeTrackerScreen extends ConsumerStatefulWidget {
  const UrgeTrackerScreen({super.key});

  @override
  ConsumerState<UrgeTrackerScreen> createState() => _UrgeTrackerScreenState();
}

class _UrgeTrackerScreenState extends ConsumerState<UrgeTrackerScreen> {
  int _currentStep = 0;
  int _intensity = 5;
  String? _trigger;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _nextStep() {
    setState(() => _currentStep++);
  }

  Future<void> _submitUrge() async {
    await ref.read(urgeNotifierProvider.notifier).logUrge(
          intensity: _intensity,
          trigger: _trigger!,
          note: _noteController.text.isEmpty ? null : _noteController.text,
        );
    setState(() => _currentStep = 3);
  }

  Color _intensityColor() {
    return Color.lerp(
      AppColors.secondary,
      AppColors.error,
      (_intensity - 1) / 9,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _buildStep(),
                ),
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
          // Back button
          GestureDetector(
            onTap: () {
              if (_currentStep > 0 && _currentStep < 3) {
                setState(() => _currentStep--);
              } else {
                context.pop();
              }
            },
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
          const SizedBox(width: AppSpacing.md),
          // Title
          Expanded(
            child: Text(
              'תעד דחף',
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          // Step indicator
          if (_currentStep < 3)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.overlayWhiteSubtle,
                borderRadius: AppRadius.borderPill,
              ),
              child: Text(
                'שלב ${_currentStep + 1} מתוך 3',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    return switch (_currentStep) {
      0 => _buildIntensityStep(),
      1 => _buildTriggerStep(),
      2 => _buildNoteStep(),
      3 => _buildDoneStep(),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildIntensityStep() {
    return Padding(
      key: const ValueKey('step_intensity'),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const Spacer(flex: 1),
          Text(
            'כמה חזק הדחף הזה?',
            style: AppTypography.headlineMedium.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxxxl),
          // Large intensity number
          Text(
            '$_intensity',
            style: AppTypography.displayLarge.copyWith(
              color: _intensityColor(),
              fontSize: 80,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          IntensitySlider(
            value: _intensity,
            onChanged: (v) => setState(() => _intensity = v),
          ),
          const Spacer(flex: 2),
          GradientButton(
            label: 'הבא',
            onPressed: _nextStep,
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildTriggerStep() {
    return Padding(
      key: const ValueKey('step_trigger'),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const Spacer(flex: 1),
          Text(
            'מה היה הטריגר לדחף הזה?',
            style: AppTypography.headlineMedium.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxxxl),
          TriggerSelector(
            selectedTrigger: _trigger,
            onTriggerSelected: (t) => setState(() => _trigger = t),
          ),
          const Spacer(flex: 2),
          GradientButton(
            label: 'הבא',
            onPressed: _trigger != null ? _nextStep : null,
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildNoteStep() {
    return Padding(
      key: const ValueKey('step_note'),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxxl),
          Text(
            'הוסף הערה (לא חובה)',
            style: AppTypography.headlineMedium.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          TextField(
            controller: _noteController,
            maxLines: 4,
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'מה קורה?',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextTertiary,
              ),
              filled: true,
              fillColor: AppColors.darkCard,
              border: OutlineInputBorder(
                borderRadius: AppRadius.borderLarge,
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.borderLarge,
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.borderLarge,
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.all(AppSpacing.lg),
            ),
          ),
          const Spacer(),
          GradientButton(
            label: 'תעד דחף',
            onPressed: _submitUrge,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _submitUrge,
              child: Text(
                'דלג',
                style: AppTypography.button.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildDoneStep() {
    return Padding(
      key: const ValueKey('step_done'),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const Spacer(flex: 2),
          const Icon(
            Icons.check_circle_rounded,
            size: 80,
            color: AppColors.secondary,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'הדחף תועד',
            style: AppTypography.headlineLarge.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              'הכרת בו במקום לפעול לפיו. זה כוח אמיתי.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Spacer(flex: 2),
          GradientButton(
            label: 'סיום',
            onPressed: () => context.pop(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'אני צריך עזרה',
            variant: AppButtonVariant.secondary,
            isFullWidth: true,
            onPressed: () {
              context.pop();
              context.push('/library/meditate');
            },
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}
