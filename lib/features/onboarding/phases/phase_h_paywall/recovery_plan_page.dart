import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';
import 'widgets/day_plan_card.dart';

/// 7-day recovery plan page: "It's not about willpower."
class RecoveryPlanPage extends StatelessWidget {
  const RecoveryPlanPage({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          // QUITTR logo
          Text(
            'QUITTR',
            style: AppTypography.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.bold,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Text(
              'It\'s not about willpower.',
              style: AppTypography.headlineLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Text(
              'It\'s about a system that actually works',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Text(
              'QUITTR guides you through a powerful 30 day reset, providing structure and tools that support your growth even beyond the break.\n\nHere\'s what your first 7 days looks like:',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.darkTextSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl),
              children: const [
                DayPlanCard(
                  title: 'Day 0 — Set up your space',
                  description:
                      'Share your digital and social environment to make change easier.',
                  icon: Icons.home_rounded,
                ),
                DayPlanCard(
                  title: 'Day 1 — Outsmart Withdrawal',
                  description:
                      'Use quick mental and physical tools to ride out urges and reset focus.',
                  icon: Icons.psychology_rounded,
                ),
                DayPlanCard(
                  title: 'Day 2 — Brain Reset Begins',
                  description:
                      'Dopamine levels begin to stabilize. Cravings may spike as your brain adjusts.',
                  icon: Icons.auto_fix_high_rounded,
                ),
                DayPlanCard(
                  title: 'Day 3 — Strengthen Your Why',
                  description:
                      'Turn your reason for quitting into daily motivation and focus.',
                  icon: Icons.gps_fixed_rounded,
                ),
                DayPlanCard(
                  title: 'Day 4 — Crush the Symptoms',
                  description:
                      'Handle low energy, sleep issues, or irritability with simple resets.',
                  icon: Icons.build_rounded,
                ),
                DayPlanCard(
                  title: 'Day 5 — Focus Returns',
                  description:
                      'The fog begins to lift, and motivation slowly returns. Stay grounded.',
                  icon: Icons.visibility_rounded,
                ),
                DayPlanCard(
                  title: 'Day 6 — You\'re Not Alone',
                  description:
                      'Connect with others on the same path. Share wins, get support.',
                  icon: Icons.groups_rounded,
                ),
                DayPlanCard(
                  title: 'Day 7 — Take Back Your Time',
                  description:
                      'Replace old habits with real goals and meaningful action.',
                  icon: Icons.schedule_rounded,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'No commitment, cancel anytime',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                GradientButton(
                  label: 'START MY JOURNEY TODAY',
                  isFullWidth: true,
                  size: AppButtonSize.large,
                  onPressed: onNext,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
