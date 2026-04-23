import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';

class _GoalItem {
  const _GoalItem(this.id, this.label, this.icon, this.color);
  final String id;
  final String label;
  final IconData icon;
  final Color color;
}

const _goals = <_GoalItem>[
  _GoalItem('energy', 'יותר אנרגיה ומוטיבציה', Icons.bolt_rounded,
      Color(0xFFFFA726)),
  _GoalItem('thoughts', 'מחשבות טהורות ובריאות',
      Icons.self_improvement_rounded, Color(0xFF66BB6A)),
  _GoalItem('relationships', 'מערכות יחסים חזקות יותר',
      Icons.favorite_rounded, Color(0xFFEF5350)),
  _GoalItem('confidence', 'ביטחון עצמי משופר',
      Icons.emoji_events_rounded, Color(0xFF42A5F5)),
  _GoalItem('control', 'שליטה עצמית משופרת', Icons.fitness_center_rounded,
      Color(0xFF78909C)),
  _GoalItem('mood', 'מצב רוח ואושר משופרים',
      Icons.sentiment_very_satisfied_rounded, Color(0xFFFFEE58)),
  _GoalItem('focus', 'ריכוז ובהירות משופרים',
      Icons.visibility_rounded, Color(0xFFAB47BC)),
];

/// Goals selection page with colorful toggle cards.
class GoalsSelectionPage extends StatefulWidget {
  const GoalsSelectionPage({
    super.key,
    required this.onComplete,
    required this.onGoalsChanged,
  });

  final VoidCallback onComplete;
  final ValueChanged<List<String>> onGoalsChanged;

  @override
  State<GoalsSelectionPage> createState() => _GoalsSelectionPageState();
}

class _GoalsSelectionPageState extends State<GoalsSelectionPage> {
  final _selected = <String>{};

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.overlayWhiteSubtle,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Text(
                  'בחר את המטרות שלך',
                  style: AppTypography.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              'בחר את המטרות שתרצה לעקוב אחריהן במהלך ההתאפסות.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl),
              itemCount: _goals.length,
              itemBuilder: (context, index) {
                return _buildGoalCard(_goals[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: AppButton(
              label: 'עקוב אחר המטרות האלו',
              isFullWidth: true,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.large,
              onPressed: () {
                widget.onGoalsChanged(_selected.toList());
                widget.onComplete();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(_GoalItem goal) {
    final isSelected = _selected.contains(goal.id);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selected.remove(goal.id);
          } else {
            _selected.add(goal.id);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? goal.color.withValues(alpha: 0.2)
              : AppColors.darkCard,
          borderRadius: AppRadius.borderPill,
          border: Border.all(
            color: isSelected
                ? goal.color.withValues(alpha: 0.6)
                : AppColors.darkBorderSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: goal.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(goal.icon, color: goal.color, size: 20),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                goal.label,
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: AppTypography.medium,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? goal.color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? goal.color : AppColors.darkBorderSubtle,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
