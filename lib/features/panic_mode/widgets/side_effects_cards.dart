import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Horizontal scrolling cards showing side effects of relapsing.
class SideEffectsCards extends StatelessWidget {
  const SideEffectsCards({super.key});

  static const _effects = [
    _Effect(Icons.psychology_rounded, 'ערפל מוחי',
        'פגיעה בזיכרון ובריכוז'),
    _Effect(Icons.trending_down_rounded, 'ירידה\nבביצועים',
        'ירידה במוטיבציה ובפרודוקטיביות'),
    _Effect(Icons.mood_bad_rounded, 'בושה\nואשמה',
        'פגיעה רגשית בערך העצמי'),
    _Effect(Icons.people_rounded, 'פגיעה\nביחסים',
        'שחיקת אמון ואינטימיות'),
    _Effect(Icons.schedule_rounded, 'בזבוז\nזמן',
        'שעות שלא חוזרות'),
    _Effect(Icons.battery_1_bar_rounded, 'ירידה\nבמוטיבציה',
        'מערכת הדופמין נחטפת'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _effects.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final effect = _effects[index];
          return Container(
            width: 140,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.errorBackground,
              borderRadius: AppRadius.borderLarge,
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(effect.icon, color: AppColors.error, size: 24),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  effect.title,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: AppTypography.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  effect.subtitle,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.darkTextSecondary,
                    fontSize: 10,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Effect {
  const _Effect(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;
}
