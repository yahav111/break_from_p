import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Bar chart showing the length (in days) of each recorded streak.
class StreakHistoryChart extends StatelessWidget {
  const StreakHistoryChart({super.key, required this.streakLengths});

  final List<int> streakLengths;

  @override
  Widget build(BuildContext context) {
    if (streakLengths.isEmpty) {
      return _buildEmptyState();
    }

    final maxY = streakLengths
            .reduce((a, b) => a > b ? a : b)
            .toDouble()
            .clamp(1.0, double.infinity) *
        1.2;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderLarge,
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY,
            minY: 0,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => AppColors.darkElevated,
                tooltipRoundedRadius: AppRadius.small,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${streakLengths[group.x.toInt()]}d',
                    AppTypography.caption.copyWith(color: Colors.white),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= streakLengths.length) {
                      return const SizedBox.shrink();
                    }
                    // Show label for last bar as "Now", others as index+1.
                    final label = idx == streakLengths.length - 1
                        ? 'Now'
                        : '#${idx + 1}';
                    return Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        label,
                        style: AppTypography.caption
                            .copyWith(color: AppColors.darkTextTertiary),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox.shrink();
                    return Text(
                      value.toInt().toString(),
                      style: AppTypography.caption
                          .copyWith(color: AppColors.darkTextTertiary),
                    );
                  },
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxY / 4,
              getDrawingHorizontalLine: (value) => FlLine(
                color: AppColors.darkBorderSubtle.withValues(alpha: 0.5),
                strokeWidth: 0.5,
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: _buildBarGroups(),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(streakLengths.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: streakLengths[i].toDouble(),
            width: streakLengths.length > 10 ? 8 : 16,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xs),
            ),
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [AppColors.primary, Color(0xFFBE3FD8)],
            ),
          ),
        ],
      );
    });
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
        height: 200,
        child: Center(
          child: Text(
            'No streaks yet',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.darkTextTertiary),
          ),
        ),
      ),
    );
  }
}
