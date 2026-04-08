import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../phases/phase_b_quiz/extended_quiz_provider.dart';
import '../../widgets/onboarding_page_template.dart';
import 'dependence_score_engine.dart';
import 'widgets/score_comparison_bar.dart';

/// "Analysis Complete" screen showing the user's dependence score.
class AnalysisCompletePage extends ConsumerWidget {
  const AnalysisCompletePage({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(extendedQuizProvider);
    final score = _computeScore(quizState);

    return OnboardingPageTemplate(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          children: [
            const Spacer(flex: 2),
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Analysis Complete',
              style: AppTypography.displayMedium.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'We\'ve got some news to break to you...',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your responses indicate a clear\ndependence on internet porn*',
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.semiBold,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            ScoreComparisonBar(
              userScore: score,
              averageScore: DependenceScoreEngine.averageScore,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '${score.round()}% higher dependence on porn',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: AppTypography.semiBold,
              ),
            ),
            const Spacer(flex: 1),
            Text(
              '* This result is an indication only, not a medical diagnosis.',
              style: AppTypography.caption.copyWith(
                color: AppColors.darkTextTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Check your symptoms',
              isFullWidth: true,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.large,
              onPressed: onNext,
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  double _computeScore(ExtendedQuizState quizState) {
    final answers = quizState.answers;
    return DependenceScoreEngine.computeScore(
      frequencyIndex: answers[1], // Q2
      escalation: answers[3] == 0, // Q4: Yes=0
      firstExposureAgeIndex: answers[4], // Q5
      arousalDependency: answers[5], // Q6
      emotionalCoping: answers[6], // Q7
      stressTrigger: answers[7], // Q8
      boredomTrigger: answers[8], // Q9
      spentMoney: answers[9] == 0, // Q10: Yes=0
    );
  }
}
