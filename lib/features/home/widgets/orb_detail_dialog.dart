import 'package:flutter/material.dart';

import '../../../core/services/streak_engine.dart';
import '../../../design_system/design_system.dart';

/// Utility to show details about a milestone orb.
abstract final class OrbDetailDialog {
  static void show(
    BuildContext context, {
    required int day,
    required String label,
    required bool isLocked,
    required int currentDays,
    String? milestoneTitle,
  }) {
    final milestone = StreakEngine.checkMilestone(day);

    final parts = <String>[];
    parts.add('יום $day');
    if (!isLocked) {
      parts.add('הושג!');
    } else {
      parts.add('${day - currentDays} ימים לסיום');
    }
    if (milestone != null) {
      parts.add('');
      parts.add(milestone.scienceMessage);
    }

    AppBottomDialog.show(
      context: context,
      title: milestoneTitle ?? label,
      message: parts.join('\n'),
      primaryButtonLabel: 'אישור',
      onPrimaryPressed: () {},
    );
  }
}
