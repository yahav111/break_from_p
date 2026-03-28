import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import 'widgets/quick_action_chip.dart';
import 'widgets/stat_card.dart';
import 'widgets/streak_card.dart';

/// Main home / dashboard screen.
/// Shows the user's current streak, stats and quick actions.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              _buildHeader(),
              const SizedBox(height: AppSpacing.xxl),
              const StreakCard(
                days: 91,
                timeLabel: '11hr 9m 2s',
                brainRewirePct: 1.0,
              ),
              const SizedBox(height: AppSpacing.xxl),
              _buildStatsRow(),
              const SizedBox(height: AppSpacing.xxl),
              _buildQuickActionsTitle(),
              const SizedBox(height: AppSpacing.lg),
              _buildQuickActionsGrid(),
              const SizedBox(height: AppSpacing.xxxxxxxxl),
            ],
          ),
        ),
      ),
    );
  }

  // ── Sub-sections ─────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good evening, Alex 👋',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            Text(
              'Day 91',
              style: AppTypography.headlineLarge.copyWith(color: Colors.white),
            ),
          ],
        ),
        _buildSettingsButton(),
      ],
    );
  }

  Widget _buildSettingsButton() {
    return Container(
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
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: const [
        Expanded(
          child: StatCard(
            label: 'Streak',
            value: '91',
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.tertiary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: StatCard(
            label: 'Pledges',
            value: '47',
            icon: Icons.handshake_rounded,
            iconColor: AppColors.secondary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: StatCard(
            label: 'Community',
            value: '2.1k',
            icon: Icons.people_rounded,
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

  Widget _buildQuickActionsGrid() {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: const [
        QuickActionChip(label: 'Meditate', icon: Icons.self_improvement_rounded),
        QuickActionChip(label: 'Journal', icon: Icons.edit_note_rounded),
        QuickActionChip(label: 'Reset', icon: Icons.refresh_rounded),
        QuickActionChip(label: 'More', icon: Icons.more_horiz_rounded),
      ],
    );
  }
}
