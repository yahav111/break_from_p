import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Line chart showing mood values over time (0-4 scale).
class MoodTrendChart extends StatelessWidget {
  const MoodTrendChart({super.key, required this.moodData});

  /// Pairs of (date, mood) sorted chronologically.
  final List<(DateTime, int)> moodData;

  static const _moodLabels = ['רע', 'נמוך', 'סביר', 'טוב', 'מעולה'];

  @override
  Widget build(BuildContext context) {
    if (moodData.isEmpty) {
      return _buildEmptyState();
    }

    final firstDate = moodData.first.$1;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderLarge,
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 4,
            clipData: const FlClipData.all(),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => AppColors.darkElevated,
                tooltipRoundedRadius: AppRadius.small,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final moodIdx = spot.y.round().clamp(0, 4);
                    return LineTooltipItem(
                      _moodLabels[moodIdx],
                      AppTypography.caption.copyWith(color: Colors.white),
                    );
                  }).toList();
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
                  interval: _bottomInterval,
                  getTitlesWidget: (value, meta) {
                    final date =
                        firstDate.add(Duration(days: value.round()));
                    return Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        '${date.day}/${date.month}',
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
                  reservedSize: 36,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx > 4) return const SizedBox.shrink();
                    return Text(
                      _moodLabels[idx],
                      style: AppTypography.caption.copyWith(
                        color: AppColors.darkTextTertiary,
                        fontSize: 9,
                      ),
                    );
                  },
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) => FlLine(
                color: AppColors.darkBorderSubtle.withValues(alpha: 0.5),
                strokeWidth: 0.5,
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [_buildLine(firstDate)],
          ),
        ),
      ),
    );
  }

  double get _bottomInterval {
    if (moodData.length <= 1) return 1;
    final totalDays =
        moodData.last.$1.difference(moodData.first.$1).inDays.toDouble();
    if (totalDays <= 7) return 1;
    if (totalDays <= 14) return 2;
    return (totalDays / 5).ceilToDouble();
  }

  LineChartBarData _buildLine(DateTime firstDate) {
    final spots = moodData.map((entry) {
      final dayOffset =
          entry.$1.difference(firstDate).inDays.toDouble();
      return FlSpot(dayOffset, entry.$2.toDouble());
    }).toList();

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.3,
      preventCurveOverShooting: true,
      barWidth: 2.5,
      gradient: const LinearGradient(
        colors: [AppColors.secondary, AppColors.primary],
      ),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 3,
            color: Color.lerp(
                    AppColors.secondary, AppColors.primary, percent / 100) ??
                AppColors.primary,
            strokeWidth: 1,
            strokeColor: Colors.white.withValues(alpha: 0.3),
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.secondary.withValues(alpha: 0.25),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
      ),
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
        height: 200,
        child: Center(
          child: Text(
            'אין עדיין נתוני מצב רוח',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.darkTextTertiary),
          ),
        ),
      ),
    );
  }
}
