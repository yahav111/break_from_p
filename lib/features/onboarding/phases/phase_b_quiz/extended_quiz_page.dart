import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../features/quiz/widgets/quiz_option_card.dart';
import '../../../../features/quiz/widgets/quiz_progress_bar.dart';
import '../../models/extended_quiz_question.dart';
import '../../widgets/onboarding_page_template.dart';
import 'extended_quiz_provider.dart';
import 'widgets/quiz_icon_option_card.dart';
import 'widgets/quiz_name_age_form.dart';

/// Extended 12-step quiz page (10 MC questions + name/age).
/// Manages its own internal step navigation via [ExtendedQuizNotifier].
class ExtendedQuizPage extends ConsumerStatefulWidget {
  const ExtendedQuizPage({
    super.key,
    required this.onComplete,
    required this.onBack,
  });

  final VoidCallback onComplete;
  final VoidCallback onBack;

  @override
  ConsumerState<ExtendedQuizPage> createState() => _ExtendedQuizPageState();
}

class _ExtendedQuizPageState extends ConsumerState<ExtendedQuizPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(extendedQuizProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: OnboardingPageTemplate(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            _buildTopBar(quizState),
            const SizedBox(height: AppSpacing.xxxl),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
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
      ),
    );
  }

  // ── Top Bar ──────────────────────────────────────────────────

  Widget _buildTopBar(ExtendedQuizState quizState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackButton(quizState),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: QuizProgressBar(progress: quizState.progress),
            ),
          ),
          _buildLanguageSelector(),
        ],
      ),
    );
  }

  Widget _buildBackButton(ExtendedQuizState quizState) {
    return GestureDetector(
      onTap: () {
        if (quizState.isFirstStep) {
          widget.onBack();
        } else {
          ref.read(extendedQuizProvider.notifier).previous();
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

  // ── Headline ──────────────────────────────────────────────────

  Widget _buildHeadline(ExtendedQuizState quizState) {
    final question = quizState.currentQuestion;
    final label = question.titleLabel;

    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          if (label != null) ...[
            Text(
              label,
              style: AppTypography.headlineLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (label == null)
            Stack(
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
        ],
      ),
    );
  }

  Widget _buildQuestionLabel(ExtendedQuizState quizState) {
    return Text(
      quizState.currentQuestion.questionText,
      style: AppTypography.bodyLarge.copyWith(
        color: AppColors.lightTextSecondary,
        height: 1.5,
        fontSize: 18,
      ),
      textAlign: TextAlign.right,
    );
  }

  // ── Step Content ──────────────────────────────────────────────

  Widget _buildStepContent(ExtendedQuizState quizState) {
    final question = quizState.currentQuestion;
    switch (question.stepType) {
      case ExtendedQuizStepType.multipleChoice:
        return _buildOptionsList(quizState);
      case ExtendedQuizStepType.multipleChoiceWithIcons:
        return _buildIconOptionsList(quizState);
      case ExtendedQuizStepType.textAndNumberInput:
        return _buildNameAgeForm(quizState);
    }
  }

  Widget _buildOptionsList(ExtendedQuizState quizState) {
    final question = quizState.currentQuestion;
    final selectedOption = quizState.answers[quizState.currentIndex];

    return Column(
      children: List.generate(question.options.length, (index) {
        return QuizOptionCard(
          index: index + 1,
          label: question.options[index],
          isSelected: selectedOption == index,
          onTap: () => _onOptionSelected(index, quizState),
        );
      }),
    );
  }

  Widget _buildIconOptionsList(ExtendedQuizState quizState) {
    final question = quizState.currentQuestion;
    final selectedOption = quizState.answers[quizState.currentIndex];

    return Column(
      children: List.generate(question.options.length, (index) {
        return QuizIconOptionCard(
          icon: question.optionIcons[index],
          label: question.options[index],
          isSelected: selectedOption == index,
          onTap: () => _onOptionSelected(index, quizState),
        );
      }),
    );
  }

  Widget _buildNameAgeForm(ExtendedQuizState quizState) {
    // Sync controllers with state.
    if (_nameController.text != quizState.name) {
      _nameController.text = quizState.name;
      _nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nameController.text.length),
      );
    }
    final ageText = quizState.age?.toString() ?? '';
    if (_ageController.text != ageText) {
      _ageController.text = ageText;
    }

    return QuizNameAgeForm(
      nameController: _nameController,
      ageController: _ageController,
      onNameChanged: (value) {
        ref.read(extendedQuizProvider.notifier).setName(value);
      },
      onAgeChanged: (value) {
        final age = int.tryParse(value);
        ref.read(extendedQuizProvider.notifier).setAge(age);
      },
      canProceed: quizState.canProceed,
      onSubmit: widget.onComplete,
    );
  }

  void _onOptionSelected(int index, ExtendedQuizState quizState) {
    ref.read(extendedQuizProvider.notifier).selectAnswer(index);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        final state = ref.read(extendedQuizProvider);
        if (state.isLastStep) {
          widget.onComplete();
        } else {
          ref.read(extendedQuizProvider.notifier).next();
        }
      }
    });
  }

  // ── Footer ──────────────────────────────────────────────────

  Widget _buildFooter(ExtendedQuizState quizState) {
    final question = quizState.currentQuestion;
    if (!question.isSkippable) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Center(
        child: AppButton(
          label: 'דלג',
          isFullWidth: false,
          variant: AppButtonVariant.ghost,
          size: AppButtonSize.small,
          onPressed: () {
            if (quizState.isLastStep) {
              widget.onComplete();
            } else {
              ref.read(extendedQuizProvider.notifier).skip();
            }
          },
        ),
      ),
    );
  }
}
