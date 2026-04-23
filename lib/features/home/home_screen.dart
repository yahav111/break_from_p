import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/achievement_provider.dart';
import '../../core/providers/app_state_provider.dart';
import '../../core/providers/live_streak_provider.dart';
import '../../core/providers/pledge_provider.dart';
import '../../core/providers/relapse_provider.dart';
import '../../core/providers/streak_provider.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../core/services/achievement_engine.dart';
import '../../core/services/streak_engine.dart';
import '../../design_system/design_system.dart';
import '../../routing/route_names.dart';
import '../achievements/widgets/achievement_toast.dart';
import '../panic_mode/panic_mode_screen.dart';
import 'widgets/milestone_celebration_dialog.dart';
import 'widgets/motivational_quote_banner.dart';
import 'widgets/pledge_card.dart';
import 'widgets/quick_action_chip.dart';
import 'widgets/reasons_section.dart';
import 'widgets/stat_card.dart';
import 'widgets/streak_card.dart';
import 'widgets/weekly_clean_days.dart';

/// Main home / dashboard screen.
/// Shows the user's current streak, stats and quick actions.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _milestoneChecked = false;
  bool _achievementsChecked = false;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileNotifierProvider);
    final streakData = ref.watch(streakNotifierProvider);
    final pledgeData = ref.watch(pledgeNotifierProvider);
    final relapseData = ref.watch(relapseNotifierProvider);
    final liveStreak = ref.watch(liveStreakProvider);
    final appState = ref.watch(appStateNotifierProvider);

    final days = streakData != null
        ? StreakEngine.daysSince(streakData.quitDate)
        : 0;
    final brainRewire = StreakEngine.brainRewireProgress(days);
    final greeting = _greeting();
    final name = profile?.name ?? 'חבר';

    final timeLabel = liveStreak.when(
      data: (d) => StreakEngine.formatDuration(d),
      loading: () => '$days ימים 0 שעות 0 דקות 0 שניות',
      error: (_, _) => '$days ימים 0 שעות 0 דקות 0 שניות',
    );

    final totalPledges = pledgeData?.pledgeDates.length ?? 0;
    final totalRelapses = relapseData?.totalRelapses ?? 0;

    // Check for new milestone to celebrate (once per build cycle).
    if (!_milestoneChecked) {
      _milestoneChecked = true;
      _checkMilestone(days, appState.lastCelebratedMilestone);
    }

    // Check for new achievements (once per build cycle).
    if (!_achievementsChecked) {
      _achievementsChecked = true;
      _checkAchievements();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0D2E), Color(0xFF080B22)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    _buildHeader(context, greeting, name, days),
                    const SizedBox(height: AppSpacing.xxl),
                    StreakCard(
                      days: days,
                      timeLabel: timeLabel,
                      brainRewirePct: brainRewire,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    if (streakData != null)
                      WeeklyCleanDays(quitDate: streakData.quitDate),
                    if (streakData != null)
                      const SizedBox(height: AppSpacing.xxl),
                    _buildStatsRow(days, totalPledges, totalRelapses),
                    const SizedBox(height: AppSpacing.xxl),
                    const PledgeCard(),
                    const SizedBox(height: AppSpacing.xxl),
                    const ReasonsSection(),
                    const SizedBox(height: AppSpacing.xxl),
                    const MotivationalQuoteBanner(),
                    const SizedBox(height: AppSpacing.xxl),
                    _buildQuickActionsTitle(),
                    const SizedBox(height: AppSpacing.lg),
                    _buildQuickActionsGrid(context, ref),
                    const SizedBox(height: AppSpacing.xxxxxxxxl),
                  ],
                ),
              ),
              Positioned(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: _buildFloatingPanicButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Sub-sections ─────────────────────────────────────────────

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'בוקר טוב';
    if (hour < 17) return 'צהריים טובים';
    return 'ערב טוב';
  }

  Widget _buildHeader(
      BuildContext context, String greeting, String name, int days) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $name \u{1F44B}',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        Text(
          'יום $days',
          style: AppTypography.headlineLarge.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildStatsRow(int days, int totalPledges, int totalRelapses) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'רצף',
            value: '$days',
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.tertiary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: StatCard(
            label: 'התחייבויות',
            value: '$totalPledges',
            icon: Icons.handshake_rounded,
            iconColor: AppColors.secondary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: StatCard(
            label: 'החלקות',
            value: '$totalRelapses',
            icon: Icons.refresh_rounded,
            iconColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsTitle() {
    return Text(
      'פעולות מהירות',
      style: AppTypography.titleMedium.copyWith(color: Colors.white),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        QuickActionChip(
          label: 'מדיטציה',
          icon: Icons.self_improvement_rounded,
          onTap: () => context.push(Routes.meditate),
        ),
        QuickActionChip(
          label: 'יומן',
          icon: Icons.edit_note_rounded,
          onTap: () => context.push(Routes.journalEntry),
        ),
        QuickActionChip(
          label: 'תעד דחף',
          icon: Icons.warning_amber_rounded,
          onTap: () => context.push(Routes.urgeTracker),
        ),
        QuickActionChip(
          label: 'איפוס',
          icon: Icons.refresh_rounded,
          onTap: () => _showResetDialog(context, ref),
        ),
      ],
    );
  }

  Widget _buildFloatingPanicButton(BuildContext context) {
    return GestureDetector(
      onTap: () => PanicModeScreen.show(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.errorBackground,
          borderRadius: AppRadius.borderPill,
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_rounded, color: AppColors.error, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'כפתור מצוקה',
              style: AppTypography.button.copyWith(color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }

  void _checkMilestone(int days, int lastCelebrated) {
    final milestone = StreakEngine.checkMilestone(days);
    if (milestone != null && days > lastCelebrated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref
              .read(appStateNotifierProvider.notifier)
              .celebrateMilestone(days);
          MilestoneCelebrationDialog.show(context, milestone);
        }
      });
    }
  }

  void _checkAchievements() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final newlyEarned = await ref
          .read(achievementNotifierProvider.notifier)
          .checkAndAward();
      if (newlyEarned.isNotEmpty && mounted) {
        final def = AchievementEngine.definitionFor(newlyEarned.first);
        if (def != null) {
          AchievementToast.show(context, def);
        }
      }
    });
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    AppBottomDialog.show(
      context: context,
      title: 'לאפס את הרצף?',
      message:
          'פעולה זו תאפס את הרצף הנוכחי שלך ליום 0. הרצף הארוך ביותר שלך יישמר. לא ניתן לבטל פעולה זו.',
      primaryButtonLabel: 'אפס רצף',
      secondaryButtonLabel: 'ביטול',
      isPrimaryDestructive: true,
      onPrimaryPressed: () {
        ref.read(streakNotifierProvider.notifier).resetStreak();
        // Reset milestone and character tracking for new streak.
        ref.read(appStateNotifierProvider.notifier).celebrateMilestone(0);
        ref.read(appStateNotifierProvider.notifier).updateCharacterStage('');
        setState(() {
          _milestoneChecked = false;
          _achievementsChecked = false;
        });
      },
    );
  }
}
