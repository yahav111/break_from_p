import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Pie chart showing exercise type breakdown.
class ExercisePieChart extends StatelessWidget {
  const ExercisePieChart({super.key, required this.exerciseCounts});

  /// Map of exercise type string to completion count.
  final Map<String, int> exerciseCounts;

  static const _typeColors = <String, Color>{
    'breathing': AppColors.secondary,
    'urge_surfing': AppColors.primary,
    'grounding': AppColors.tertiary,
    'body_scan': AppColors.info,
  };

  static const _typeLabels = <String, String>{
    'breathing': 'Breathing',
    'urge_surfing': 'Urge Surfing',
    'grounding': 'Grounding',
    'body_scan': 'Body Scan',
  };

  @override
  Widget build(BuildContext context) {
    if (exerciseCounts.isEmpty) {
      return _buildEmptyState();
    }

    final total = exerciseCounts.values.fold<int>(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderLarge,
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 30,
                sections: _buildSections(total),
                pieTouchData: PieTouchData(enabled: false),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildLegend(total),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(int total) {
    return exerciseCounts.entries.map((entry) {
      final color = _typeColors[entry.key] ?? AppColors.darkTextTertiary;
      final percentage =
          total > 0 ? (entry.value / total * 100).round() : 0;

      return PieChartSectionData(
        value: entry.value.toDouble(),
        color: color,
        radius: 40,
        title: '$percentage%',
        titleStyle: AppTypography.caption.copyWith(
          color: Colors.white,
          fontWeight: AppTypography.semiBold,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }

  Widget _buildLegend(int total) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      alignment: WrapAlignment.center,
      children: exerciseCounts.entries.map((entry) {
        final color = _typeColors[entry.key] ?? AppColors.darkTextTertiary;
        final label = _typeLabels[entry.key] ?? entry.key;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '$label (${entry.value})',
              style: AppTypography.caption
                  .copyWith(color: AppColors.darkTextSecondary),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderLarge,
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: SizedBox(
        height: 150,
        child: Center(
          child: Text(
            'No exercises completed yet',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.darkTextTertiary),
          ),
        ),
      ),
    );
  }
}
