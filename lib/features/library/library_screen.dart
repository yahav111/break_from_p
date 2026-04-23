import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design_system/design_system.dart';
import '../../routing/route_names.dart';
import 'widgets/library_category_card.dart';

/// Content hub showing the four library categories:
/// Mood, Meditate, Lifetree, and Soundscapes.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'ספרייה',
                  style: AppTypography.headlineLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'ארגז הכלים להחלמה',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // 2x2 category grid
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    LibraryCategoryCard(
                      title: 'מצב רוח',
                      subtitle: 'עקוב ושקף',
                      imagePath: 'assets/images/mood.jpeg',
                      color: AppColors.tertiary,
                      onTap: () => context.push(Routes.moodHistory),
                    ),
                    LibraryCategoryCard(
                      title: 'מדיטציה',
                      subtitle: 'תרגילים ונשימה',
                      imagePath: 'assets/images/meditate.jpeg',
                      color: AppColors.secondary,
                      onTap: () => context.push(Routes.meditate),
                    ),
                    LibraryCategoryCard(
                      title: 'עץ החיים',
                      subtitle: 'פתח תוכן בונוס',
                      imagePath: 'assets/images/lifetree.jpeg',
                      color: AppColors.primary,
                      onTap: () => context.push(Routes.lifetree),
                    ),
                    LibraryCategoryCard(
                      title: 'נופים קוליים',
                      subtitle: 'צלילי רקע',
                      imagePath: 'assets/images/soundscapes.jpeg',
                      color: AppColors.info,
                      onTap: () => context.push(Routes.soundscapes),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
