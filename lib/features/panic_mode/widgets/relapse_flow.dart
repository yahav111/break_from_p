import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_state_provider.dart';
import '../../../core/providers/relapse_provider.dart';
import '../../../core/providers/streak_provider.dart';
import '../../../core/services/streak_engine.dart';
import '../../../design_system/design_system.dart';
import '../../../routing/route_names.dart';

/// Relapse confirmation and recording flow.
/// Shows confirmation dialog, optional reason input, then records relapse.
class RelapseFlow extends ConsumerStatefulWidget {
  const RelapseFlow({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  ConsumerState<RelapseFlow> createState() => _RelapseFlowState();
}

class _RelapseFlowState extends ConsumerState<RelapseFlow> {
  final _reasonController = TextEditingController();
  bool _confirmed = false;
  bool _processing = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _recordRelapse() async {
    setState(() => _processing = true);

    final streakData = ref.read(streakNotifierProvider);
    final daysLost =
        streakData != null ? StreakEngine.daysSince(streakData.quitDate) : 0;

    final reason = _reasonController.text.trim();

    await ref.read(relapseNotifierProvider.notifier).recordRelapse(
          reason: reason.isEmpty ? null : reason,
          streakDaysLost: daysLost,
        );
    await ref.read(streakNotifierProvider.notifier).resetStreak();

    // Reset milestone celebration for the new streak.
    await ref.read(appStateNotifierProvider.notifier).celebrateMilestone(0);

    if (mounted) {
      setState(() => _confirmed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_confirmed) return _buildRecoveryMessage(context);
    return _buildConfirmation();
  }

  Widget _buildConfirmation() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button.
          GestureDetector(
            onTap: widget.onBack,
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
          const SizedBox(height: AppSpacing.xxl),

          Text(
            'זה בסדר.',
            style: AppTypography.headlineLarge.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'החלמה אינה קו ישר. מה שחשוב זה שאתה ממשיך.',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          // Optional reason.
          Text(
            'מה היה הטריגר? (לא חובה)',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _reasonController,
            style: AppTypography.bodyMedium.copyWith(color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'זה יעזור לך לזהות דפוסים...',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextTertiary,
              ),
              filled: true,
              fillColor: AppColors.darkElevated,
              border: OutlineInputBorder(
                borderRadius: AppRadius.borderMedium,
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(AppSpacing.lg),
            ),
          ),
          const Spacer(),

          // Confirm button.
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: _processing ? 'מעדכן...' : 'אשר איפוס',
              variant: AppButtonVariant.danger,
              onPressed: _processing ? null : _recordRelapse,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'חזור',
              variant: AppButtonVariant.ghost,
              onPressed: widget.onBack,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildRecoveryMessage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.15),
              ),
              child: Icon(
                Icons.favorite_rounded,
                color: AppColors.secondary,
                size: 40,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'אתה עדיין כאן.\nזה דורש אומץ.',
              style: AppTypography.headlineMedium.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'כל יום הוא התחלה חדשה. הרצף שלך אופס, אבל המסע שלך ממשיך.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxxxl),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'חזרה לבית',
                variant: AppButtonVariant.primary,
                onPressed: () => context.go(Routes.home),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
