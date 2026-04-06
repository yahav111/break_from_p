import 'package:flutter/material.dart';

import '../models/character_stage.dart';

/// Pure calculation functions for character evolution.
/// Maps streak days to character stages with display metadata.
abstract final class CharacterEngine {
  /// Day thresholds for each character stage.
  static const stageThresholds = <CharacterStage, int>{
    CharacterStage.sprout: 0,
    CharacterStage.ember: 1,
    CharacterStage.flame: 7,
    CharacterStage.blaze: 14,
    CharacterStage.phoenix: 30,
    CharacterStage.nova: 60,
    CharacterStage.cosmos: 90,
  };

  /// Returns the character stage for the given streak [days].
  static CharacterStage stageForDays(int days) {
    var result = CharacterStage.sprout;
    for (final entry in stageThresholds.entries) {
      if (days >= entry.value) result = entry.key;
    }
    return result;
  }

  /// Display name for a character stage.
  static String stageName(CharacterStage stage) {
    return switch (stage) {
      CharacterStage.sprout => 'Sprout',
      CharacterStage.ember => 'Ember',
      CharacterStage.flame => 'Flame',
      CharacterStage.blaze => 'Blaze',
      CharacterStage.phoenix => 'Phoenix',
      CharacterStage.nova => 'Nova',
      CharacterStage.cosmos => 'Cosmos',
    };
  }

  /// Flavor text describing the character stage.
  static String stageDescription(CharacterStage stage) {
    return switch (stage) {
      CharacterStage.sprout =>
        'A tiny seed of change. Your journey begins here.',
      CharacterStage.ember =>
        'A spark ignites within. You are gathering strength.',
      CharacterStage.flame =>
        'Growing stronger every day. The fire is taking hold.',
      CharacterStage.blaze =>
        'Burning bright with determination. Nothing can stop you.',
      CharacterStage.phoenix =>
        'Reborn from the ashes. A new version of yourself emerges.',
      CharacterStage.nova =>
        'Radiating power and purpose. Your light inspires others.',
      CharacterStage.cosmos =>
        'Transcendent. You have mastered yourself and reached the stars.',
    };
  }

  /// The minimum streak days required for a stage.
  static int stageMinDays(CharacterStage stage) {
    return stageThresholds[stage] ?? 0;
  }

  /// Primary and secondary colors for a stage (used by painters).
  static (Color, Color) stageColors(CharacterStage stage) {
    return switch (stage) {
      CharacterStage.sprout => (const Color(0xFF4ECB71), const Color(0xFF2E8B57)),
      CharacterStage.ember => (const Color(0xFFFF9F43), const Color(0xFFE67E22)),
      CharacterStage.flame => (const Color(0xFFFF6B6B), const Color(0xFFFF4757)),
      CharacterStage.blaze => (const Color(0xFFFFD700), const Color(0xFFFF8C00)),
      CharacterStage.phoenix => (const Color(0xFFFF6EC7), const Color(0xFFBE3FD8)),
      CharacterStage.nova => (const Color(0xFF7B61FF), const Color(0xFF4ECBFF)),
      CharacterStage.cosmos => (const Color(0xFFFFFFFF), const Color(0xFFD0D8FF)),
    };
  }
}
