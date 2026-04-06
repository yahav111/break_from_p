import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/lifetree_provider.dart';
import '../../../core/services/lifetree_engine.dart';
import '../../../design_system/design_system.dart';

/// Shows a bottom dialog for a Lifetree node — preview, unlock, or launch.
abstract final class LifetreeNodeDialog {
  static void show({
    required BuildContext context,
    required WidgetRef ref,
    required LifetreeNode node,
    required bool isUnlocked,
    required bool isUnlockable,
  }) {
    if (node.isComingSoon) {
      _showComingSoon(context, node);
    } else if (isUnlocked) {
      _showUnlocked(context, ref, node);
    } else if (isUnlockable) {
      _showUnlockable(context, ref, node);
    } else {
      _showLocked(context, node);
    }
  }

  // ── Coming soon ──────────────────────────────────────────────────

  static void _showComingSoon(BuildContext context, LifetreeNode node) {
    AppBottomDialog.show(
      context: context,
      title: node.title,
      message: '${node.description}\n\nComing soon!',
      primaryButtonLabel: 'OK',
      onPrimaryPressed: () {},
    );
  }

  // ── Locked ───────────────────────────────────────────────────────

  static void _showLocked(BuildContext context, LifetreeNode node) {
    final requirement = node.unlockCondition.describe();

    AppBottomDialog.show(
      context: context,
      title: node.title,
      message: '${node.description}\n\nUnlock requirement: $requirement',
      primaryButtonLabel: 'OK',
      onPrimaryPressed: () {},
    );
  }

  // ── Unlockable ───────────────────────────────────────────────────

  static void _showUnlockable(
    BuildContext context,
    WidgetRef ref,
    LifetreeNode node,
  ) {
    AppBottomDialog.show(
      context: context,
      title: node.title,
      message: '${node.description}\n\nReady to unlock!',
      primaryButtonLabel: 'Unlock',
      secondaryButtonLabel: 'Cancel',
      onPrimaryPressed: () {
        ref.read(lifetreeNotifierProvider.notifier).unlockNode(node.id);
        _navigateToContent(context, node);
      },
      onSecondaryPressed: () {},
    );
  }

  // ── Unlocked ─────────────────────────────────────────────────────

  static void _showUnlocked(
    BuildContext context,
    WidgetRef ref,
    LifetreeNode node,
  ) {
    AppBottomDialog.show(
      context: context,
      title: node.title,
      message: node.description,
      primaryButtonLabel: 'Start',
      secondaryButtonLabel: 'Close',
      onPrimaryPressed: () => _navigateToContent(context, node),
      onSecondaryPressed: () {},
    );
  }

  // ── Navigation ───────────────────────────────────────────────────

  static void _navigateToContent(BuildContext context, LifetreeNode node) {
    switch (node.category) {
      case LifetreeCategory.breathing:
        if (node.breathingParams != null) {
          context.push(
            '/library/meditate/breathing',
            extra: node.breathingParams,
          );
        }
      case LifetreeCategory.journaling:
        context.push('/journal/entry');
      case LifetreeCategory.meditation:
        if (node.id == 'meditation_body_scan') {
          context.push('/library/meditate/body-scan');
        }
      case LifetreeCategory.soundscapes:
        // Soundscape nodes are marked as coming soon; no-op.
        break;
    }
  }
}
