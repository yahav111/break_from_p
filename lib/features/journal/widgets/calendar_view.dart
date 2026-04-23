import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/journal_entry.dart';
import '../../../design_system/design_system.dart';

/// Month calendar grid widget showing journal entry dots per day.
class CalendarView extends StatefulWidget {
  const CalendarView({
    super.key,
    required this.entries,
    this.onDaySelected,
  });

  final List<JournalEntry> entries;
  final ValueChanged<DateTime>? onDaySelected;

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _currentMonth;

  static const _dayLabels = ['ב', 'ג', 'ד', 'ה', 'ו', 'ש', 'א'];

  static const _moodColors = <int, Color>{
    0: AppColors.error,
    1: AppColors.tertiary,
    2: AppColors.darkTextSecondary,
    3: AppColors.secondary,
    4: AppColors.primary,
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMonthHeader(),
        const SizedBox(height: AppSpacing.lg),
        _buildDayLabels(),
        const SizedBox(height: AppSpacing.sm),
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 28,
          ),
          onPressed: _previousMonth,
        ),
        Text(
          DateFormat('MMMM y', 'he_IL').format(_currentMonth),
          style: AppTypography.titleMedium.copyWith(color: Colors.white),
        ),
        IconButton(
          icon: const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white,
            size: 28,
          ),
          onPressed: _nextMonth,
        ),
      ],
    );
  }

  Widget _buildDayLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _dayLabels.map((label) {
        return SizedBox(
          width: 40,
          child: Center(
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.darkTextTertiary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    // Monday = 1, Sunday = 7. We want Monday as first column.
    final firstWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    // Offset: Monday=0, Tuesday=1, ..., Sunday=6.
    final startOffset = firstWeekday - 1;
    final totalCells = startOffset + daysInMonth;
    final rowCount = ((totalCells) / 7).ceil();

    final now = DateTime.now();
    final isCurrentMonth =
        _currentMonth.year == now.year && _currentMonth.month == now.month;

    // Build a map of day -> entry mood for this month.
    final entryMap = <int, JournalEntry>{};
    for (final entry in widget.entries) {
      if (entry.date.year == _currentMonth.year &&
          entry.date.month == _currentMonth.month) {
        // Keep the latest entry for each day.
        entryMap[entry.date.day] = entry;
      }
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: rowCount * 7,
      itemBuilder: (context, index) {
        final dayNumber = index - startOffset + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final isToday = isCurrentMonth && dayNumber == now.day;
        final entry = entryMap[dayNumber];
        final hasEntry = entry != null;
        final moodColor = hasEntry
            ? (_moodColors[entry.mood] ?? AppColors.darkTextSecondary)
            : null;

        return GestureDetector(
          onTap: hasEntry
              ? () {
                  widget.onDaySelected?.call(
                    DateTime(_currentMonth.year, _currentMonth.month, dayNumber),
                  );
                }
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: isToday
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      )
                    : null,
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: AppTypography.bodySmall.copyWith(
                      color: hasEntry
                          ? Colors.white
                          : AppColors.darkTextTertiary,
                      fontWeight: isToday
                          ? AppTypography.semiBold
                          : AppTypography.regular,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              if (hasEntry)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: moodColor,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + 1,
      );
    });
  }
}
