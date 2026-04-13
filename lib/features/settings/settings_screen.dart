import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/app_state_provider.dart';
import '../../core/providers/notification_preferences_provider.dart';
import '../../core/providers/pledge_provider.dart';
import '../../core/providers/reasons_provider.dart';
import '../../core/providers/relapse_provider.dart';
import '../../core/providers/streak_provider.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../core/services/streak_engine.dart';
import '../../data/sync/sync_engine.dart';
import '../../data/sync/sync_status.dart';
import '../../design_system/design_system.dart';
import '../../infrastructure/auth/auth_provider.dart';
import '../../infrastructure/auth/auth_state.dart';
import '../../routing/route_names.dart';
import 'widgets/profile_edit_sheet.dart';
import 'widgets/settings_section.dart';

/// Full-screen settings page accessible from home gear icon or profile tab.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileNotifierProvider);
    final streakData = ref.watch(streakNotifierProvider);
    final notifPrefs = ref.watch(notifPrefsNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final syncStatus = ref.watch(syncEngineProvider);
    final days = streakData != null
        ? StreakEngine.daysSince(streakData.quitDate)
        : 0;

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
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.lg),

                      // Profile header.
                      _buildProfileHeader(profile, days),
                      const SizedBox(height: AppSpacing.xxl),

                      // Profile section.
                      SettingsSection(
                        title: 'Profile',
                        children: [
                          _buildTile(
                            icon: Icons.person_rounded,
                            title: 'Name',
                            value: profile?.name ?? 'Not set',
                            onTap: () => ProfileEditSheet.show(context),
                          ),
                          _buildTile(
                            icon: Icons.calendar_today_rounded,
                            title: 'Quit Date',
                            value: profile != null
                                ? '${profile.quitDate.day}/${profile.quitDate.month}/${profile.quitDate.year}'
                                : 'Not set',
                            onTap: () => ProfileEditSheet.show(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Account & Cloud Backup section.
                      SettingsSection(
                        title: 'Account',
                        children: [
                          _buildTile(
                            icon: _syncIcon(syncStatus.state),
                            title: 'Backup Status',
                            value: _syncLabel(syncStatus.state),
                          ),
                          if (authState.status == AuthStatus.anonymous) ...[
                            _buildTile(
                              icon: Icons.g_mobiledata_rounded,
                              title: 'Sign in with Google',
                              showChevron: true,
                              onTap: () => _signInWithGoogle(context, ref),
                            ),
                            _buildTile(
                              icon: Icons.apple_rounded,
                              title: 'Sign in with Apple',
                              showChevron: true,
                              onTap: () => _signInWithApple(context, ref),
                            ),
                          ],
                          if (authState.status ==
                              AuthStatus.authenticated) ...[
                            _buildTile(
                              icon: Icons.account_circle_rounded,
                              title: 'Account',
                              value: authState.email ?? authState.displayName,
                            ),
                            _buildTile(
                              icon: Icons.logout_rounded,
                              title: 'Sign Out',
                              onTap: () => _showSignOutDialog(context, ref),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Notifications section.
                      SettingsSection(
                        title: 'Notifications',
                        children: [
                          _buildToggleTile(
                            icon: Icons.wb_sunny_rounded,
                            title: 'Morning Pledge',
                            subtitle: _formatTime(
                              notifPrefs.morningPledgeHour,
                              notifPrefs.morningPledgeMinute,
                            ),
                            value: notifPrefs.morningPledgeEnabled,
                            onChanged: (v) => ref
                                .read(notifPrefsNotifierProvider.notifier)
                                .toggleMorningPledge(v),
                          ),
                          _buildToggleTile(
                            icon: Icons.emoji_events_rounded,
                            title: 'Milestones',
                            value: notifPrefs.milestoneEnabled,
                            onChanged: (v) => ref
                                .read(notifPrefsNotifierProvider.notifier)
                                .toggleMilestone(v),
                          ),
                          _buildToggleTile(
                            icon: Icons.format_quote_rounded,
                            title: 'Daily Motivation',
                            value: notifPrefs.dailyMotivationEnabled,
                            onChanged: (v) => ref
                                .read(notifPrefsNotifierProvider.notifier)
                                .toggleDailyMotivation(v),
                          ),
                          _buildToggleTile(
                            icon: Icons.nightlight_round,
                            title: 'Evening Check-in',
                            subtitle: _formatTime(
                              notifPrefs.eveningCheckInHour,
                              notifPrefs.eveningCheckInMinute,
                            ),
                            value: notifPrefs.eveningCheckInEnabled,
                            onChanged: (v) => ref
                                .read(notifPrefsNotifierProvider.notifier)
                                .toggleEveningCheckIn(v),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Recovery section.
                      SettingsSection(
                        title: 'Recovery',
                        children: [
                          _buildTile(
                            icon: Icons.refresh_rounded,
                            title: 'Reset Streak',
                            titleColor: AppColors.error,
                            onTap: () => _showResetDialog(context, ref),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Data section.
                      SettingsSection(
                        title: 'Data',
                        children: [
                          _buildTile(
                            icon: Icons.delete_forever_rounded,
                            title: 'Delete All Data',
                            titleColor: AppColors.error,
                            onTap: () => _showDeleteDialog(context, ref),
                          ),
                          if (authState.isSignedIn)
                            _buildTile(
                              icon: Icons.person_remove_rounded,
                              title: 'Delete Account',
                              titleColor: AppColors.error,
                              onTap: () =>
                                  _showDeleteAccountDialog(context, ref),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // About section.
                      SettingsSection(
                        title: 'About',
                        children: [
                          _buildTile(
                            icon: Icons.info_outline_rounded,
                            title: 'Version',
                            value: '1.0.0',
                          ),
                          _buildTile(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Privacy Policy',
                            showChevron: true,
                          ),
                          _buildTile(
                            icon: Icons.description_outlined,
                            title: 'Terms of Service',
                            showChevron: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxxxl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          if (canPop) ...[
            GestureDetector(
              onTap: () => context.pop(),
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
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
          ],
          Text(
            'Settings',
            style: AppTypography.headlineSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(dynamic profile, int days) {
    final name = profile?.name ?? 'Friend';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Center(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF7B61FF), Color(0xFFBE3FD8)],
              ),
            ),
            child: Center(
              child: Text(
                initial,
                style: AppTypography.headlineMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTypography.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            name,
            style: AppTypography.titleMedium.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Day $days',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    String? value,
    Color? titleColor,
    bool showChevron = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon,
                color: titleColor ?? AppColors.darkTextSecondary, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: titleColor ?? Colors.white,
                ),
              ),
            ),
            if (value != null)
              Text(
                value,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.darkTextTertiary,
                ),
              ),
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.darkTextTertiary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.darkTextSecondary, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.darkTextTertiary,
                    ),
                  ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  IconData _syncIcon(SyncState state) {
    switch (state) {
      case SyncState.synced:
        return Icons.cloud_done_rounded;
      case SyncState.syncing:
        return Icons.cloud_sync_rounded;
      case SyncState.error:
        return Icons.cloud_off_rounded;
      case SyncState.offline:
        return Icons.cloud_off_rounded;
      case SyncState.idle:
        return Icons.cloud_outlined;
    }
  }

  String _syncLabel(SyncState state) {
    switch (state) {
      case SyncState.synced:
        return 'Synced';
      case SyncState.syncing:
        return 'Syncing...';
      case SyncState.error:
        return 'Sync error';
      case SyncState.offline:
        return 'Offline';
      case SyncState.idle:
        return 'Not synced';
    }
  }

  String _formatTime(int hour, int minute) {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  void _signInWithApple(BuildContext context, WidgetRef ref) {
    ref.read(authNotifierProvider.notifier).signInWithApple();
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    AppBottomDialog.show(
      context: context,
      title: 'Sign Out?',
      message:
          'Your data will remain on this device but will no longer sync to the cloud.',
      primaryButtonLabel: 'Sign Out',
      secondaryButtonLabel: 'Cancel',
      onPrimaryPressed: () {
        ref.read(authNotifierProvider.notifier).signOut();
      },
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    AppBottomDialog.show(
      context: context,
      title: 'Reset Streak?',
      message:
          'This will reset your current streak to Day 0. Your longest streak will be saved.',
      primaryButtonLabel: 'Reset Streak',
      secondaryButtonLabel: 'Cancel',
      isPrimaryDestructive: true,
      onPrimaryPressed: () {
        ref.read(streakNotifierProvider.notifier).resetStreak();
      },
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    AppBottomDialog.show(
      context: context,
      title: 'Delete All Data?',
      message:
          'This will permanently erase all your data including streaks, pledges, relapses, and reasons. You will be returned to the welcome screen.',
      primaryButtonLabel: 'Delete Everything',
      secondaryButtonLabel: 'Cancel',
      isPrimaryDestructive: true,
      onPrimaryPressed: () async {
        // Clear all provider data (deletes from both Hive and Firestore
        // if using SyncedRepository).
        final pledgeRepo = ref.read(pledgeRepositoryProvider);
        final relapseRepo = ref.read(relapseRepositoryProvider);
        final reasonsRepo = ref.read(reasonsRepositoryProvider);
        final streakRepo = ref.read(streakRepositoryProvider);
        final userRepo = ref.read(userProfileRepositoryProvider);
        final notifPrefsRepo = ref.read(notifPrefsRepositoryProvider);

        await Future.wait([
          pledgeRepo.delete(),
          relapseRepo.delete(),
          reasonsRepo.delete(),
          streakRepo.delete(),
          userRepo.delete(),
          notifPrefsRepo.delete(),
        ]);

        // Reset app state to trigger redirect to onboarding.
        await ref.read(appStateNotifierProvider.notifier).resetAllState();

        if (context.mounted) {
          context.go(Routes.welcome);
        }
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    AppBottomDialog.show(
      context: context,
      title: 'Delete Account?',
      message:
          'This will permanently delete your account and all cloud data. This action cannot be undone.',
      primaryButtonLabel: 'Delete Account',
      secondaryButtonLabel: 'Cancel',
      isPrimaryDestructive: true,
      onPrimaryPressed: () async {
        // Delete all local data first.
        final pledgeRepo = ref.read(pledgeRepositoryProvider);
        final relapseRepo = ref.read(relapseRepositoryProvider);
        final reasonsRepo = ref.read(reasonsRepositoryProvider);
        final streakRepo = ref.read(streakRepositoryProvider);
        final userRepo = ref.read(userProfileRepositoryProvider);
        final notifPrefsRepo = ref.read(notifPrefsRepositoryProvider);

        await Future.wait([
          pledgeRepo.delete(),
          relapseRepo.delete(),
          reasonsRepo.delete(),
          streakRepo.delete(),
          userRepo.delete(),
          notifPrefsRepo.delete(),
        ]);

        // Delete Firebase Auth account (also orphans Firestore data).
        await ref.read(authNotifierProvider.notifier).deleteAccount();

        // Reset app state.
        await ref.read(appStateNotifierProvider.notifier).resetAllState();

        if (context.mounted) {
          context.go(Routes.welcome);
        }
      },
    );
  }
}
