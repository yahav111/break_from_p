import 'package:flutter/material.dart';

import '../../../../core/models/character_stage.dart';
import 'blaze_painter.dart';
import 'cosmos_painter.dart';
import 'ember_painter.dart';
import 'flame_painter.dart';
import 'nova_painter.dart';
import 'phoenix_painter.dart';
import 'sprout_painter.dart';

/// Returns the appropriate [CustomPainter] for the given character [stage],
/// driven by [animationValue] (0.0 - 1.0 repeating) for idle animations.
CustomPainter characterPainterFor(
  CharacterStage stage,
  double animationValue,
) {
  return switch (stage) {
    CharacterStage.sprout => SproutPainter(animationValue: animationValue),
    CharacterStage.ember => EmberPainter(animationValue: animationValue),
    CharacterStage.flame => FlamePainter(animationValue: animationValue),
    CharacterStage.blaze => BlazePainter(animationValue: animationValue),
    CharacterStage.phoenix => PhoenixPainter(animationValue: animationValue),
    CharacterStage.nova => NovaPainter(animationValue: animationValue),
    CharacterStage.cosmos => CosmosPainter(animationValue: animationValue),
  };
}
