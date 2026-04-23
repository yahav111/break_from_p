import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/models/quiz_question.dart';
import '../../core/providers/quiz_provider.dart';
import '../../core/providers/streak_provider.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../design_system/design_system.dart';
import '../../routing/route_names.dart';
import '../../shared/widgets/star_field.dart';
import 'widgets/quiz_option_card.dart';
import 'widgets/quiz_progress_bar.dart';

/// Interactive quiz screen with multi-step flow:
/// Step 1: Name input, Steps 2-6: MC questions, Step 7: Date picker.
class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _completeQuiz() async {
    final quizState = ref.read(quizNotifierProvider);

    // Create user profile from quiz data.
    await ref.read(userProfileNotifierProvider.notifier).createProfile(
          name: quizState.name,
          quitDate: quizState.quitDate ?? DateTime.now(),
          quizAnswers: quizState.answers,
        );

    // Start streak from quit date.
    await ref.read(streakNotifierProvider.notifier).startStreak(
          quizState.quitDate ?? DateTime.now(),
        );

    if (mounted) {
      context.go(Routes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          const StarField(density: 65),
          _buildContent(quizState),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkBackground,
      ),
    );
  }

  Widget _buildContent(QuizState quizState) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          _buildTopBar(quizState),
          const SizedBox(height: AppSpacing.xxxl),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeadline(quizState),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildQuestionLabel(quizState),
                  const SizedBox(height: AppSpacing.xxxxxl),
                  _buildStepContent(quizState),
                ],
              ),
            ),
          ),
          _buildFooter(quizState),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildTopBar(QuizState quizState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackButton(quizState),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: QuizProgressBar(progress: quizState.progress),
            ),
          ),
          _buildLanguageSelector(),
        ],
      ),
    );
  }

  Widget _buildBackButton(QuizState quizState) {
    return GestureDetector(
      onTap: () {
        if (quizState.isFirstStep) {
          context.go(Routes.welcome);
        } else {
          ref.read(quizNotifierProvider.notifier).previous();
        }
      },
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
          size: 22,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderPill,
        border: Border.all(color: AppColors.darkBorderSubtle, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('\u{1F1EE}\u{1F1F1}', style: TextStyle(fontSize: 14)),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'עב',
            style: AppTypography.labelLarge.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadline(QuizState quizState) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            'שאלה #${quizState.currentIndex + 1}',
            style: AppTypography.displayMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.bold,
            ),
          ),
          Positioned(
            bottom: -2,
            left: 0,
            child: Container(
              height: 3,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.borderPill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionLabel(QuizState quizState) {
    return Text(
      quizState.currentQuestion.questionText,
      style: AppTypography.bodyLarge.copyWith(
        color: AppColors.lightTextSecondary,
        height: 1.5,
        fontSize: 18,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget _buildStepContent(QuizState quizState) {
    final question = quizState.currentQuestion;
    switch (question.stepType) {
      case QuizStepType.textInput:
        return _buildNameInput(quizState);
      case QuizStepType.multipleChoice:
        return _buildOptionsList(quizState);
      case QuizStepType.datePicker:
        return _buildDatePicker(quizState);
    }
  }

  Widget _buildNameInput(QuizState quizState) {
    // Sync controller with state on step change.
    if (_nameController.text != quizState.name) {
      _nameController.text = quizState.name;
      _nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nameController.text.length),
      );
    }

    return Column(
      children: [
        TextField(
          controller: _nameController,
          autofocus: true,
          style: AppTypography.bodyLarge.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: quizState.currentQuestion.placeholder,
            hintStyle: AppTypography.bodyLarge.copyWith(
              color: AppColors.darkTextTertiary,
            ),
            filled: true,
            fillColor: AppColors.darkCard,
            border: OutlineInputBorder(
              borderRadius: AppRadius.borderPill,
              borderSide: BorderSide(
                color: AppColors.darkBorderSubtle,
                width: 0.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.borderPill,
              borderSide: BorderSide(
                color: AppColors.darkBorderSubtle,
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.borderPill,
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
          ),
          onChanged: (value) {
            ref.read(quizNotifierProvider.notifier).setName(value);
          },
          textInputAction: TextInputAction.next,
          onSubmitted: (_) {
            if (quizState.canProceed) {
              ref.read(quizNotifierProvider.notifier).next();
            }
          },
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppButton(
          label: 'המשך',
          isFullWidth: true,
          variant: AppButtonVariant.primary,
          size: AppButtonSize.large,
          icon: Icons.arrow_forward_rounded,
          iconPosition: AppButtonIconPosition.trailing,
          onPressed: quizState.canProceed
              ? () => ref.read(quizNotifierProvider.notifier).next()
              : null,
        ),
      ],
    );
  }

  Widget _buildOptionsList(QuizState quizState) {
    final question = quizState.currentQuestion;
    final selectedOption = quizState.answers[quizState.currentIndex];

    return Column(
      children: List.generate(question.options.length, (index) {
        return QuizOptionCard(
          index: index + 1,
          label: question.options[index],
          isSelected: selectedOption == index,
          onTap: () {
            ref.read(quizNotifierProvider.notifier).selectAnswer(index);
            // Auto-advance after a short delay for animation.
            Future.delayed(const Duration(milliseconds: 400), () {
              if (mounted) {
                final state = ref.read(quizNotifierProvider);
                if (state.isLastStep) {
                  _completeQuiz();
                } else {
                  ref.read(quizNotifierProvider.notifier).next();
                }
              }
            });
          },
        );
      }),
    );
  }

  Widget _buildDatePicker(QuizState quizState) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showDatePicker(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: AppRadius.borderPill,
              border: Border.all(
                color: quizState.quitDate != null
                    ? AppColors.primary
                    : AppColors.darkBorderSubtle,
                width: quizState.quitDate != null ? 1.5 : 0.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  _formatDate(quizState.quitDate ?? _selectedDate),
                  style: AppTypography.bodyLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.darkTextSecondary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        GradientButton(
          label: 'התחל את המסע שלי',
          isFullWidth: true,
          size: AppButtonSize.large,
          onPressed: () {
            if (quizState.quitDate == null) {
              ref.read(quizNotifierProvider.notifier).setQuitDate(_selectedDate);
            }
            _completeQuiz();
          },
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.darkSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _selectedDate = picked;
      ref.read(quizNotifierProvider.notifier).setQuitDate(picked);
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('d בMMMM y', 'he_IL').format(date);
  }

  Widget _buildFooter(QuizState quizState) {
    final question = quizState.currentQuestion;
    // Skip button only for non-required MC questions.
    if (question.stepType != QuizStepType.multipleChoice || question.isRequired) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Align(
        alignment: Alignment.center,
        child: AppButton(
          label: 'דלג',
          isFullWidth: false,
          variant: AppButtonVariant.secondary,
          size: AppButtonSize.small,
          onPressed: () {
            if (quizState.isLastStep) {
              _completeQuiz();
            } else {
              ref.read(quizNotifierProvider.notifier).skip();
            }
          },
        ),
      ),
    );
  }
}
