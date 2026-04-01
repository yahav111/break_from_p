import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/app_state_provider.dart';
import '../../core/providers/live_streak_provider.dart';
import '../../core/providers/pledge_provider.dart';
import '../../core/providers/relapse_provider.dart';
import '../../core/providers/streak_provider.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../core/services/streak_engine.dart';
import '../../design_system/design_system.dart';
import '../../routing/route_names.dart';
import 'widgets/milestone_celebration_dialog.dart';
import 'widgets/pledge_card.dart';
import 'widgets/quick_action_chip.dart';
import 'widgets/reasons_section.dart';
import 'widgets/stat_card.dart';
import 'widgets/streak_card.dart';

/// Main home / dashboard screen.
/// Shows the user's current streak, stats and quick actions.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _milestoneChecked = false;

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
    final name = profile?.name ?? 'Friend';

    final timeLabel = liveStreak.when(
      data: (d) => StreakEngine.formatDuration(d),
      loading: () => '${days}d 0h 0m 0s',
      error: (_, _) => '${days}d 0h 0m 0s',
    );

    final totalPledges = pledgeData?.pledgeDates.length ?? 0;
    final totalRelapses = relapseData?.totalRelapses ?? 0;

    // Check for new milestone to celebrate (once per build cycle).
    if (!_milestoneChecked) {
      _milestoneChecked = true;
      _checkMilestone(days, appState.lastCelebratedMilestone);
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0D2E), Color(0xFF080B22)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
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
                onPanicPressed: () => context.push(Routes.panicMode),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _buildStatsRow(days, totalPledges, totalRelapses),
              const SizedBox(height: AppSpacing.xxl),
              const PledgeCard(),
              const SizedBox(height: AppSpacing.xxl),
              const ReasonsSection(),
              const SizedBox(height: AppSpacing.xxl),
              _buildQuickActionsTitle(),
              const SizedBox(height: AppSpacing.lg),
              _buildQuickActionsGrid(context, ref),
              const SizedBox(height: AppSpacing.xxxxxxxxl),
            ],
          ),
        ),
      ),
    );
  }

  // ── Sub-sections ─────────────────────────────────────────────

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildHeader(
      BuildContext context, String greeting, String name, int days) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, $name \u{1F44B}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            Text(
              'Day $days',
              style: AppTypography.headlineLarge.copyWith(color: Colors.white),
            ),
          ],
        ),
        _buildSettingsButton(context),
      ],
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.settings),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.overlayWhiteSubtle,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.settings_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildStatsRow(int days, int totalPledges, int totalRelapses) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Streak',
            value: '$days',
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.tertiary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: StatCard(
            label: 'Pledges',
            value: '$totalPledges',
            icon: Icons.handshake_rounded,
            iconColor: AppColors.secondary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: StatCard(
            label: 'Relapses',
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
      'Quick Actions',
      style: AppTypography.titleMedium.copyWith(color: Colors.white),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        const QuickActionChip(
          label: 'Meditate',
          icon: Icons.self_improvement_rounded,
        ),
        const QuickActionChip(
          label: 'Journal',
          icon: Icons.edit_note_rounded,
        ),
        QuickActionChip(
          label: 'Reset',
          icon: Icons.refresh_rounded,
          onTap: () => _showResetDialog(context, ref),
        ),
        const QuickActionChip(label: 'More', icon: Icons.more_horiz_rounded),
      ],
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

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    AppBottomDialog.show(
      context: context,
      title: 'Reset Streak?',
      message:
          'This will reset your current streak to Day 0. Your longest streak will be saved. This action cannot be undone.',
      primaryButtonLabel: 'Reset Streak',
      secondaryButtonLabel: 'Cancel',
      isPrimaryDestructive: true,
      onPrimaryPressed: () {
        ref.read(streakNotifierProvider.notifier).resetStreak();
        // Reset milestone tracking for new streak.
        ref.read(appStateNotifierProvider.notifier).celebrateMilestone(0);
        setState(() => _milestoneChecked = false);
      },
    );
  }
}
