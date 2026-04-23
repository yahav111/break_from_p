import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import 'widgets/course_lesson_card.dart';

/// Mini digital course — "Content" tab.
class CourseScreen extends ConsumerWidget {
  const CourseScreen({super.key});

  static const _lessons = [
    _Lesson(
      title: 'להבין את ההתמכרות',
      subtitle: 'איך פורנו מעצב מחדש את המוח',
      videoAsset: 'assets/videos/vid1.mp4',
      durationLabel: 'שיעור 1',
    ),
    _Lesson(
      title: 'מלכודת הדופמין',
      subtitle: 'שבירת מעגל הסיפוק המיידי',
      videoAsset: 'assets/videos/vid2.mp4',
      durationLabel: 'שיעור 2',
    ),
    _Lesson(
      title: 'בניית הרגלים חדשים',
      subtitle: 'החלפת דפוסים ישנים בשגרות בריאות',
      videoAsset: 'assets/videos/vid3.mp4',
      durationLabel: 'שיעור 3',
    ),
    _Lesson(
      title: 'החלמה ארוכת טווח',
      subtitle: 'להישאר מחויבים למסע שלך',
      videoAsset: 'assets/videos/vid4.mp4',
      durationLabel: 'שיעור 4',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'תוכן',
                        style: AppTypography.headlineLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'קורס המיני שלך להחלמה',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.darkTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 9 / 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final lesson = _lessons[index];
                      return CourseLessonCard(
                        index: index,
                        title: lesson.title,
                        subtitle: lesson.subtitle,
                        videoAsset: lesson.videoAsset,
                        durationLabel: lesson.durationLabel,
                      );
                    },
                    childCount: _lessons.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxxxxxxxl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Lesson {
  const _Lesson({
    required this.title,
    required this.subtitle,
    required this.videoAsset,
    required this.durationLabel,
  });

  final String title;
  final String subtitle;
  final String videoAsset;
  final String durationLabel;
}
