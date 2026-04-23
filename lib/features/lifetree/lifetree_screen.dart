import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/exercise_provider.dart';
import '../../core/providers/journal_provider.dart';
import '../../core/providers/lifetree_provider.dart';
import '../../core/providers/streak_provider.dart';
import '../../core/services/lifetree_engine.dart';
import '../../core/services/streak_engine.dart';
import '../../design_system/design_system.dart';
import 'widgets/lifetree_canvas.dart';
import 'widgets/lifetree_node_dialog.dart';

/// Constellation-themed skill tree where users unlock bonus content
/// as they progress through their recovery journey.
class LifetreeScreen extends ConsumerWidget {
  const LifetreeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lifetreeData = ref.watch(lifetreeNotifierProvider);
    final streakData = ref.watch(streakNotifierProvider);
    final exerciseData = ref.watch(exerciseNotifierProvider);
    final journalData = ref.watch(journalNotifierProvider);

    final unlockedIds = lifetreeData?.unlockedNodeIds.toSet() ?? <String>{};
    final streakDays = streakData != null
        ? StreakEngine.daysSince(streakData.quitDate)
        : 0;
    final exerciseCount = exerciseData?.totalCompleted ?? 0;
    final journalEntries = journalData?.entries.length ?? 0;
    final totalNodes = LifetreeEngine.nodes.length;
    final unlockedCount = unlockedIds.length;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              _buildSubtitle(),
              _buildProgress(unlockedCount, totalNodes),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: LifetreeCanvas(
                  unlockedNodeIds: unlockedIds,
                  streakDays: streakDays,
                  exerciseCount: exerciseCount,
                  journalEntries: journalEntries,
                  onNodeTap: (node) => LifetreeNodeDialog.show(
                    context: context,
                    ref: ref,
                    node: node,
                    isUnlocked: unlockedIds.contains(node.id),
                    isUnlockable: !node.isComingSoon &&
                        LifetreeEngine.isUnlockable(
                          node,
                          streakDays: streakDays,
                          exercises: exerciseCount,
                          journalEntries: journalEntries,
                        ),
                  ),
                ),
              ),
              _buildLegend(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
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
            'עץ החיים',
            style: AppTypography.headlineSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        'פתח תוכן בונוס ככל שאתה מתקדם',
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
        ),
      ),
    );
  }

  Widget _buildProgress(int unlocked, int total) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
      ),
      child: Text(
        '$unlocked מתוך $total נקודות נפתחו',
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.darkTextTertiary,
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _LegendDot(color: Color(0xFF4ECB71), label: 'נשימה'),
          _LegendDot(color: Color(0xFF7B61FF), label: 'יומן'),
          _LegendDot(color: Color(0xFF4ECBFF), label: 'מדיטציה'),
          _LegendDot(color: Color(0xFFFF9F43), label: 'נופים קוליים'),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.darkTextTertiary,
          ),
        ),
      ],
    );
  }
}
