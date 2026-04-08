import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Status of a single day in the weekly checklist.
enum _DayStatus { clean, relapsed, today, future }

/// 7 circles representing the current week (Sun-Sat).
/// Green check for clean days, highlighted for today, grey for future.
class WeeklyCleanDays extends StatelessWidget {
  const WeeklyCleanDays({super.key, required this.quitDate});

  /// The date the user's current streak began.
  final DateTime quitDate;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final quitDay = DateTime(quitDate.year, quitDate.month, quitDate.day);

    // Find the Sunday that starts the current week.
    final weekStart = today.subtract(Duration(days: today.weekday % 7));

    const dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderLarge,
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week',
            style: AppTypography.caption.copyWith(
              color: AppColors.darkTextSecondary,
              fontWeight: AppTypography.semiBold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: List.generate(7, (i) {
              final day = weekStart.add(Duration(days: i));
              final status = _statusFor(day, today, quitDay);

              return Expanded(
                child: _DayCircle(
                  label: dayLabels[i],
                  status: status,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  _DayStatus _statusFor(DateTime day, DateTime today, DateTime quitDay) {
    if (day.isAfter(today)) return _DayStatus.future;
    if (day.isAtSameMomentAs(today)) {
      // Today is clean if streak is active (quitDay is today or earlier).
      return day.isAfter(quitDay)
          ? _DayStatus.today
          : _DayStatus.today;
    }
    // Past day: clean if within current streak (on or after quit date).
    if (!day.isBefore(quitDay)) return _DayStatus.clean;
    return _DayStatus.relapsed;
  }
}

class _DayCircle extends StatelessWidget {
  const _DayCircle({required this.label, required this.status});

  final String label;
  final _DayStatus status;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Widget? icon;

    switch (status) {
      case _DayStatus.clean:
        bgColor = AppColors.success.withValues(alpha: 0.15);
        borderColor = AppColors.success.withValues(alpha: 0.4);
        icon = Icon(Icons.check_rounded, color: AppColors.success, size: 16);
      case _DayStatus.relapsed:
        bgColor = AppColors.error.withValues(alpha: 0.12);
        borderColor = AppColors.error.withValues(alpha: 0.3);
        icon = Icon(Icons.remove_rounded, color: AppColors.error, size: 14);
      case _DayStatus.today:
        bgColor = AppColors.primary.withValues(alpha: 0.2);
        borderColor = AppColors.primary.withValues(alpha: 0.6);
        icon = Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        );
      case _DayStatus.future:
        bgColor = AppColors.darkElevated.withValues(alpha: 0.4);
        borderColor = AppColors.darkBorderSubtle;
        icon = null;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Center(child: icon),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: status == _DayStatus.future
                ? AppColors.darkTextTertiary
                : AppColors.darkTextSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
