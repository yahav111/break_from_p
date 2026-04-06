import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A cluster of warm particles that flicker and drift.
/// Represents the first sparks of determination.
class EmberPainter extends CustomPainter {
  EmberPainter({required this.animationValue});

  final double animationValue;

  static const _primary = Color(0xFFFF9F43);
  static const _secondary = Color(0xFFE67E22);
  static const _hot = Color(0xFFFFD700);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final maxR = math.min(cx, cy);
    final t = animationValue * math.pi * 2;

    // --- Warm ambient glow ---
    final ambientPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        maxR * 0.7,
        [
          _primary.withValues(alpha: 0.15),
          _primary.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawCircle(center, maxR * 0.7, ambientPaint);

    // --- Ember particles ---
    final particles = <_EmberParticle>[
      _EmberParticle(
        baseOffset: Offset(cx, cy),
        baseRadius: maxR * 0.13,
        phase: 0.0,
        brightness: 1.0,
      ),
      _EmberParticle(
        baseOffset: Offset(cx - maxR * 0.22, cy - maxR * 0.15),
        baseRadius: maxR * 0.09,
        phase: 0.8,
        brightness: 0.8,
      ),
      _EmberParticle(
        baseOffset: Offset(cx + maxR * 0.25, cy - maxR * 0.1),
        baseRadius: maxR * 0.10,
        phase: 1.6,
        brightness: 0.85,
      ),
      _EmberParticle(
        baseOffset: Offset(cx - maxR * 0.08, cy + maxR * 0.25),
        baseRadius: maxR * 0.08,
        phase: 2.5,
        brightness: 0.7,
      ),
      _EmberParticle(
        baseOffset: Offset(cx + maxR * 0.15, cy + maxR * 0.2),
        baseRadius: maxR * 0.07,
        phase: 3.5,
        brightness: 0.75,
      ),
      _EmberParticle(
        baseOffset: Offset(cx - maxR * 0.28, cy + maxR * 0.1),
        baseRadius: maxR * 0.06,
        phase: 4.2,
        brightness: 0.6,
      ),
      _EmberParticle(
        baseOffset: Offset(cx + maxR * 0.3, cy + maxR * 0.05),
        baseRadius: maxR * 0.055,
        phase: 5.1,
        brightness: 0.65,
      ),
    ];

    for (final p in particles) {
      // Flicker: particles drift slightly
      final drift = Offset(
        math.sin(t + p.phase) * maxR * 0.04,
        math.cos(t * 1.3 + p.phase) * maxR * 0.04,
      );
      final pos = p.baseOffset + drift;

      // Size pulse
      final sizePulse = 0.85 + 0.15 * math.sin(t * 1.5 + p.phase);
      final r = p.baseRadius * sizePulse;

      // Outer glow
      final glowPaint = Paint()
        ..shader = ui.Gradient.radial(
          pos,
          r * 2.5,
          [
            _primary.withValues(alpha: 0.2 * p.brightness),
            Colors.transparent,
          ],
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(pos, r * 2.5, glowPaint);

      // Core gradient
      final corePaint = Paint()
        ..shader = ui.Gradient.radial(
          Offset(pos.dx - r * 0.2, pos.dy - r * 0.2),
          r * 1.5,
          [
            Color.lerp(_hot, _primary, 1.0 - p.brightness)!,
            _secondary,
          ],
        );
      canvas.drawCircle(pos, r, corePaint);

      // Hot center highlight
      final hotPaint = Paint()
        ..shader = ui.Gradient.radial(
          Offset(pos.dx - r * 0.15, pos.dy - r * 0.15),
          r * 0.6,
          [
            Colors.white.withValues(alpha: 0.6 * p.brightness * sizePulse),
            Colors.white.withValues(alpha: 0.0),
          ],
        );
      canvas.drawCircle(pos, r * 0.5, hotPaint);
    }

    // --- Rising spark motes ---
    for (var i = 0; i < 4; i++) {
      final sparkPhase = (animationValue + i * 0.25) % 1.0;
      final sparkX = cx + math.sin(i * 1.7 + t * 0.5) * maxR * 0.3;
      final sparkY = cy - sparkPhase * maxR * 0.8;
      final sparkAlpha = (1.0 - sparkPhase) * 0.6;
      final sparkR = maxR * 0.02 * (1.0 - sparkPhase * 0.5);

      final sparkPaint = Paint()
        ..color = _hot.withValues(alpha: sparkAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(Offset(sparkX, sparkY), sparkR, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(EmberPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class _EmberParticle {
  const _EmberParticle({
    required this.baseOffset,
    required this.baseRadius,
    required this.phase,
    required this.brightness,
  });

  final Offset baseOffset;
  final double baseRadius;
  final double phase;
  final double brightness;
}
