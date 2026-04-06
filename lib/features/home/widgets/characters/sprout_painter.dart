import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A tiny seed with concentric glow rings that pulse outward.
/// Simple and humble -- the beginning of transformation.
class SproutPainter extends CustomPainter {
  SproutPainter({required this.animationValue});

  final double animationValue;

  static const _primary = Color(0xFF4ECB71);
  static const _secondary = Color(0xFF2E8B57);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final maxR = math.min(cx, cy);

    // Breathing factor: gentle 0.92 - 1.0 pulse
    final breath = 0.92 + 0.08 * math.sin(animationValue * math.pi * 2);

    // --- Outer glow rings (3 rings pulsing outward) ---
    for (var i = 3; i >= 1; i--) {
      final phase = (animationValue + i * 0.15) % 1.0;
      final ringRadius = maxR * (0.35 + 0.55 * phase) * breath;
      final ringOpacity = (1.0 - phase) * 0.18;
      final ringPaint = Paint()
        ..color = _primary.withValues(alpha: ringOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(center, ringRadius, ringPaint);
    }

    // --- Soft ambient glow ---
    final glowPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        maxR * 0.45 * breath,
        [
          _primary.withValues(alpha: 0.25),
          _primary.withValues(alpha: 0.08),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawCircle(center, maxR * 0.45 * breath, glowPaint);

    // --- Core seed ---
    final coreRadius = maxR * 0.18 * breath;

    // Seed body gradient
    final corePaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx - coreRadius * 0.3, cy - coreRadius * 0.3),
        coreRadius * 2,
        [_primary, _secondary],
      );
    canvas.drawCircle(center, coreRadius, corePaint);

    // Inner bright highlight
    final highlightPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx - coreRadius * 0.2, cy - coreRadius * 0.25),
        coreRadius * 0.7,
        [
          Colors.white.withValues(alpha: 0.7),
          Colors.white.withValues(alpha: 0.0),
        ],
      );
    canvas.drawCircle(center, coreRadius * 0.6, highlightPaint);

    // --- Tiny sprout shoot growing upward ---
    final shootHeight = maxR * 0.22 * breath;
    final shootPath = Path()
      ..moveTo(cx - 2.5, cy - coreRadius)
      ..quadraticBezierTo(
        cx - 4,
        cy - coreRadius - shootHeight * 0.6,
        cx,
        cy - coreRadius - shootHeight,
      )
      ..quadraticBezierTo(
        cx + 4,
        cy - coreRadius - shootHeight * 0.6,
        cx + 2.5,
        cy - coreRadius,
      )
      ..close();

    final shootPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(cx, cy - coreRadius),
        Offset(cx, cy - coreRadius - shootHeight),
        [_secondary, _primary],
      );
    canvas.drawPath(shootPath, shootPaint);

    // Shoot glow
    final shootGlow = Paint()
      ..color = _primary.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(shootPath, shootGlow);
  }

  @override
  bool shouldRepaint(SproutPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
