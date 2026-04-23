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
                        title: 'פרופיל',
                        children: [
                          _buildTile(
                            icon: Icons.person_rounded,
                            title: 'שם',
                            value: profile?.name ?? 'לא הוגדר',
                            onTap: () => ProfileEditSheet.show(context),
                          ),
                          _buildTile(
                            icon: Icons.calendar_today_rounded,
                            title: 'תאריך התחלה',
                            value: profile != null
                                ? '${profile.quitDate.day}/${profile.quitDate.month}/${profile.quitDate.year}'
                                : 'לא הוגדר',
                            onTap: () => ProfileEditSheet.show(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Account & Cloud Backup section.
                      SettingsSection(
                        title: 'חשבון',
                        children: [
                          _buildTile(
                            icon: _syncIcon(syncStatus.state),
                            title: 'סטטוס גיבוי',
                            value: _syncLabel(syncStatus.state),
                          ),
                          if (authState.status == AuthStatus.anonymous) ...[
                            _buildTile(
                              icon: Icons.g_mobiledata_rounded,
                              title: 'התחבר עם Google',
                              showChevron: true,
                              onTap: () => _signInWithGoogle(context, ref),
                            ),
                            _buildTile(
                              icon: Icons.apple_rounded,
                              title: 'התחבר עם Apple',
                              showChevron: true,
                              onTap: () => _signInWithApple(context, ref),
                            ),
                          ],
                          if (authState.status ==
                              AuthStatus.authenticated) ...[
                            _buildTile(
                              icon: Icons.account_circle_rounded,
                              title: 'חשבון',
                              value: authState.email ?? authState.displayName,
                            ),
                            _buildTile(
                              icon: Icons.logout_rounded,
                              title: 'התנתק',
                              onTap: () => _showSignOutDialog(context, ref),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Notifications section.
                      SettingsSection(
                        title: 'התראות',
                        children: [
                          _buildToggleTile(
                            icon: Icons.wb_sunny_rounded,
                            title: 'התחייבות בוקר',
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
                            title: 'אבני דרך',
                            value: notifPrefs.milestoneEnabled,
                            onChanged: (v) => ref
                                .read(notifPrefsNotifierProvider.notifier)
                                .toggleMilestone(v),
                          ),
                          _buildToggleTile(
                            icon: Icons.format_quote_rounded,
                            title: 'מוטיבציה יומית',
                            value: notifPrefs.dailyMotivationEnabled,
                            onChanged: (v) => ref
                                .read(notifPrefsNotifierProvider.notifier)
                                .toggleDailyMotivation(v),
                          ),
                          _buildToggleTile(
                            icon: Icons.nightlight_round,
                            title: 'צ׳ק-אין ערב',
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
                        title: 'החלמה',
                        children: [
                          _buildTile(
                            icon: Icons.refresh_rounded,
                            title: 'אפס רצף',
                            titleColor: AppColors.error,
                            onTap: () => _showResetDialog(context, ref),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Data section.
                      SettingsSection(
                        title: 'נתונים',
                        children: [
                          _buildTile(
                            icon: Icons.delete_forever_rounded,
                            title: 'מחק את כל הנתונים',
                            titleColor: AppColors.error,
                            onTap: () => _showDeleteDialog(context, ref),
                          ),
                          if (authState.isSignedIn)
                            _buildTile(
                              icon: Icons.person_remove_rounded,
                              title: 'מחק חשבון',
                              titleColor: AppColors.error,
                              onTap: () =>
                                  _showDeleteAccountDialog(context, ref),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // About section.
                      SettingsSection(
                        title: 'אודות',
                        children: [
                          _buildTile(
                            icon: Icons.info_outline_rounded,
                            title: 'גרסה',
                            value: '1.0.0',
                          ),
                          _buildTile(
                            icon: Icons.privacy_tip_outlined,
                            title: 'מדיניות פרטיות',
                            showChevron: true,
                          ),
                          _buildTile(
                            icon: Icons.description_outlined,
                            title: 'תנאי שימוש',
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
            'הגדרות',
            style: AppTypography.headlineSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(dynamic profile, int days) {
    final name = profile?.name ?? 'חבר';
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
            'יום $days',
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
        return 'מסונכרן';
      case SyncState.syncing:
        return 'מסנכרן...';
      case SyncState.error:
        return 'שגיאת סנכרון';
      case SyncState.offline:
        return 'לא מקוון';
      case SyncState.idle:
        return 'לא מסונכרן';
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
      title: 'להתנתק?',
      message:
          'הנתונים שלך יישארו במכשיר הזה אך לא יסתנכרנו יותר לענן.',
      primaryButtonLabel: 'התנתק',
      secondaryButtonLabel: 'ביטול',
      onPrimaryPressed: () async {
        await ref.read(authNotifierProvider.notifier).signOut();
        await ref.read(appStateNotifierProvider.notifier).resetAllState();
        if (context.mounted) {
          context.go(Routes.welcome);
        }
      },
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    AppBottomDialog.show(
      context: context,
      title: 'לאפס את הרצף?',
      message:
          'פעולה זו תאפס את הרצף הנוכחי ליום 0. הרצף הארוך ביותר שלך יישמר.',
      primaryButtonLabel: 'אפס רצף',
      secondaryButtonLabel: 'ביטול',
      isPrimaryDestructive: true,
      onPrimaryPressed: () {
        ref.read(streakNotifierProvider.notifier).resetStreak();
      },
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    AppBottomDialog.show(
      context: context,
      title: 'למחוק את כל הנתונים?',
      message:
          'פעולה זו תמחק לצמיתות את כל הנתונים שלך כולל רצפים, התחייבויות, החלקות וסיבות. תוחזר למסך הפתיחה.',
      primaryButtonLabel: 'מחק הכל',
      secondaryButtonLabel: 'ביטול',
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
      title: 'למחוק חשבון?',
      message:
          'פעולה זו תמחק לצמיתות את החשבון שלך ואת כל נתוני הענן. לא ניתן לבטל פעולה זו.',
      primaryButtonLabel: 'מחק חשבון',
      secondaryButtonLabel: 'ביטול',
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
