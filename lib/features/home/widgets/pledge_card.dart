import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/pledge_provider.dart';
import '../../../design_system/design_system.dart';

/// Daily pledge card shown on the home screen.
/// Two states: unpledged (shows CTA) and pledged (shows confirmation).
class PledgeCard extends ConsumerStatefulWidget {
  const PledgeCard({super.key});

  @override
  ConsumerState<PledgeCard> createState() => _PledgeCardState();
}

class _PledgeCardState extends ConsumerState<PledgeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  bool _justPledged = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _makePledge() async {
    await ref.read(pledgeNotifierProvider.notifier).makePledge();
    setState(() => _justPledged = true);
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final hasPledged = ref.watch(pledgeNotifierProvider.select((_) {
      return ref.read(pledgeNotifierProvider.notifier).hasPledgedToday;
    }));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: hasPledged ? _buildPledgedState() : _buildUnpledgedState(),
    );
  }

  Widget _buildUnpledgedState() {
    return Container(
      key: const ValueKey('unpledged'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderExtraLarge,
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Column(
        children: [
          Icon(
            Icons.handshake_rounded,
            color: AppColors.secondary,
            size: 32,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'אני מתחייב להישאר נקי היום',
            style: AppTypography.titleSmall.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'התחייב',
              variant: AppButtonVariant.primary,
              onPressed: _makePledge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPledgedState() {
    return Container(
      key: const ValueKey('pledged'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: AppRadius.borderExtraLarge,
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_justPledged)
            ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                Icons.check_circle_rounded,
                color: AppColors.secondary,
                size: 24,
              ),
            )
          else
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.secondary,
              size: 24,
            ),
          const SizedBox(width: AppSpacing.md),
          Text(
            'התחייבת היום',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
