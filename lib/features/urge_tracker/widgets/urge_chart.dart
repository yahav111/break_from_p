import 'package:flutter/material.dart';

import '../../../core/models/urge_entry.dart';
import '../../../design_system/design_system.dart';

/// Simple horizontal bar chart showing urge distribution across 4 time-of-day
/// blocks: Morning (6-12), Afternoon (12-18), Evening (18-24), Night (0-6).
class UrgeChart extends StatelessWidget {
  const UrgeChart({
    super.key,
    required this.entries,
  });

  /// All urge entries to visualize.
  final List<UrgeEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
        child: Center(
          child: Text(
            'No patterns yet',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextTertiary,
            ),
          ),
        ),
      );
    }

    final buckets = _groupByTimeOfDay();
    final maxCount = buckets.values.fold<int>(0, (a, b) => a > b ? a : b);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBar(context, 'Morning', '6am-12pm', buckets['morning'] ?? 0, maxCount),
        const SizedBox(height: AppSpacing.sm),
        _buildBar(context, 'Afternoon', '12pm-6pm', buckets['afternoon'] ?? 0, maxCount),
        const SizedBox(height: AppSpacing.sm),
        _buildBar(context, 'Evening', '6pm-12am', buckets['evening'] ?? 0, maxCount),
        const SizedBox(height: AppSpacing.sm),
        _buildBar(context, 'Night', '12am-6am', buckets['night'] ?? 0, maxCount),
      ],
    );
  }

  Map<String, int> _groupByTimeOfDay() {
    final buckets = <String, int>{
      'morning': 0,
      'afternoon': 0,
      'evening': 0,
      'night': 0,
    };

    for (final entry in entries) {
      final hour = entry.timestamp.hour;
      if (hour >= 6 && hour < 12) {
        buckets['morning'] = buckets['morning']! + 1;
      } else if (hour >= 12 && hour < 18) {
        buckets['afternoon'] = buckets['afternoon']! + 1;
      } else if (hour >= 18 && hour < 24) {
        buckets['evening'] = buckets['evening']! + 1;
      } else {
        buckets['night'] = buckets['night']! + 1;
      }
    }

    return buckets;
  }

  Widget _buildBar(
    BuildContext context,
    String label,
    String sublabel,
    int count,
    int maxCount,
  ) {
    final fraction = maxCount > 0 ? count / maxCount : 0.0;

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
              Text(
                sublabel,
                style: AppTypography.caption.copyWith(
                  color: AppColors.darkTextTertiary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth * fraction;
              return Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    height: 24,
                    width: barWidth.clamp(count > 0 ? 4.0 : 0.0, constraints.maxWidth),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.borderPill,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '$count',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
