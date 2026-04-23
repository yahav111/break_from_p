import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/achievement_provider.dart';
import '../../core/providers/pledge_provider.dart';
import '../../core/providers/relapse_provider.dart';
import '../../core/providers/streak_provider.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../core/services/achievement_engine.dart';
import '../../core/services/streak_engine.dart';
import '../../design_system/design_system.dart';
import '../../routing/route_names.dart';

/// Profile tab showing user summary and access to settings.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileNotifierProvider);
    final streakData = ref.watch(streakNotifierProvider);
    final pledgeData = ref.watch(pledgeNotifierProvider);
    final relapseData = ref.watch(relapseNotifierProvider);

    final name = profile?.name ?? 'חבר';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final days = streakData != null
        ? StreakEngine.daysSince(streakData.quitDate)
        : 0;
    final totalPledges = pledgeData?.pledgeDates.length ?? 0;
    final totalRelapses = relapseData?.totalRelapses ?? 0;
    final achievementData = ref.watch(achievementNotifierProvider);
    final unlockedCount = achievementData?.entries.length ?? 0;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxxl),

              // Avatar.
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B61FF), Color(0xFFBE3FD8)],
                  ),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: AppTypography.displayLarge.copyWith(
                      color: Colors.white,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                name,
                style:
                    AppTypography.headlineMedium.copyWith(color: Colors.white),
              ),
              if (profile != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'התחיל ${profile.quitDate.day}/${profile.quitDate.month}/${profile.quitDate.year}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xxxl),

              // Quick stats.
              Row(
                children: [
                  _buildStat('רצף', '$days ימים', AppColors.tertiary),
                  const SizedBox(width: AppSpacing.md),
                  _buildStat('התחייבויות', '$totalPledges', AppColors.secondary),
                  const SizedBox(width: AppSpacing.md),
                  _buildStat('החלקות', '$totalRelapses', AppColors.primary),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // Phase 4: Gamification tiles.
              _buildNavTile(
                icon: Icons.military_tech_rounded,
                title: 'הישגים',
                trailing: '$unlockedCount/${AchievementEngine.definitions.length}',
                onTap: () => context.push(Routes.badges),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildNavTile(
                icon: Icons.bar_chart_rounded,
                title: 'סטטיסטיקה',
                onTap: () => context.push(Routes.statistics),
              ),
              const SizedBox(height: AppSpacing.md),

              // Settings tile.
              _buildNavTile(
                icon: Icons.settings_rounded,
                title: 'הגדרות',
                onTap: () => context.push(Routes.settings),
              ),
              const SizedBox(height: AppSpacing.xxxxl),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: AppRadius.borderLarge,
          border: Border.all(color: AppColors.darkBorderSubtle),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.titleLarge.copyWith(
                color: color,
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: AppRadius.borderLarge,
          border: Border.all(color: AppColors.darkBorderSubtle),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.darkTextSecondary, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style:
                    AppTypography.bodyLarge.copyWith(color: Colors.white),
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing,
                style: AppTypography.caption.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.darkTextTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
