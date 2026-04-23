import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/achievement_provider.dart';
import '../../core/services/achievement_engine.dart';
import '../../design_system/design_system.dart';
import 'widgets/badge_tile.dart';

/// Full-screen badge collection showing all 18 achievements in a grid.
/// Pushed from Profile screen.
class BadgeCollectionScreen extends ConsumerWidget {
  const BadgeCollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementData = ref.watch(achievementNotifierProvider);
    final unlockedIds = <String>{};
    final unlockedDates = <String, DateTime>{};

    if (achievementData != null) {
      for (final entry in achievementData.entries) {
        unlockedIds.add(entry.id);
        unlockedDates[entry.id] = entry.unlockedAt;
      }
    }

    final unlockedCount = unlockedIds.length;
    final totalCount = AchievementEngine.definitions.length;

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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Text(
                  '$unlockedCount מתוך $totalCount נפתחו',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.75,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: AchievementEngine.definitions.map((def) {
                      final isUnlocked = unlockedIds.contains(def.id);
                      return BadgeTile(
                        def: def,
                        isUnlocked: isUnlocked,
                        unlockedAt: unlockedDates[def.id],
                      );
                    }).toList(),
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
            'הישגים',
            style: AppTypography.headlineSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
