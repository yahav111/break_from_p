import 'package:flutter/material.dart';

enum DependenceSeverity { mild, moderate, high, severe }

class RecoveryBenefit {
  const RecoveryBenefit({
    required this.id,
    required this.label,
    required this.emoji,
    required this.color,
    required this.priority,
  });

  final String id;
  final String label;
  final String emoji;
  final Color color;
  final int priority;
}

class DayPlanEntry {
  const DayPlanEntry({
    required this.dayLabel,
    required this.description,
    required this.icon,
  });

  final String dayLabel;
  final String description;
  final IconData icon;
}

class RecoveryWeekPoint {
  const RecoveryWeekPoint({
    required this.weekIndex,
    required this.quittr,
    required this.conventional,
    required this.relapses,
  });

  final int weekIndex;
  final double quittr;
  final double conventional;
  final double relapses;
}

class RecoveryPlan {
  const RecoveryPlan({
    required this.totalDays,
    required this.totalWeeks,
    required this.estimatedQuitDate,
    required this.severity,
    required this.dependenceScore,
    required this.benefits,
    required this.dayPlan,
    required this.weeks,
  });

  final int totalDays;
  final int totalWeeks;
  final DateTime estimatedQuitDate;
  final DependenceSeverity severity;
  final double dependenceScore;
  final List<RecoveryBenefit> benefits;
  final List<DayPlanEntry> dayPlan;
  final List<RecoveryWeekPoint> weeks;
}
