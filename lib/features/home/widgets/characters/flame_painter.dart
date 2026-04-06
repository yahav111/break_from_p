import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A teardrop flame shape with bezier curves, inner bright core,
/// and outer gradient. Sways gently with animation.
class FlamePainter extends CustomPainter {
  FlamePainter({required this.animationValue});

  final double animationValue;

  static const _primary = Color(0xFFFF6B6B);
  static const _secondary = Color(0xFFFF4757);
  static const _core = Color(0xFFFFD700);
  static const _white = Color(0xFFFFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxR = math.min(cx, cy);
    final t = animationValue * math.pi * 2;

    // Sway offset
    final sway = math.sin(t) * maxR * 0.04;

    // Flame dimensions
    final flameH = maxR * 1.3;
    final flameW = maxR * 0.55;
    final flameBase = cy + maxR * 0.35;
    final flameTip = flameBase - flameH;

    // Tip wavering
    final tipWaver = math.sin(t * 1.8) * maxR * 0.06;

    // --- Outer glow ---
    final glowPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx + sway, cy - maxR * 0.1),
        maxR * 0.85,
        [
          _primary.withValues(alpha: 0.2),
          _primary.withValues(alpha: 0.05),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawCircle(Offset(cx + sway, cy - maxR * 0.1), maxR * 0.85, glowPaint);

    // --- Outer flame ---
    final outerFlame = _buildFlamePath(
      cx: cx + sway,
      base: flameBase,
      tip: flameTip + tipWaver,
      width: flameW,
      bulgeFactor: 0.65,
    );

    final outerPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(cx, flameBase),
        Offset(cx, flameTip),
        [
          _secondary,
          _primary,
          _primary.withValues(alpha: 0.4),
        ],
        [0.0, 0.6, 1.0],
      );
    canvas.drawPath(outerFlame, outerPaint);

    // Outer flame blur
    final outerGlow = Paint()
      ..shader = ui.Gradient.linear(
        Offset(cx, flameBase),
        Offset(cx, flameTip),
        [
          _secondary.withValues(alpha: 0.3),
          _primary.withValues(alpha: 0.1),
        ],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawPath(outerFlame, outerGlow);

    // --- Middle flame layer ---
    final midFlame = _buildFlamePath(
      cx: cx + sway * 0.7,
      base: flameBase - flameH * 0.05,
      tip: flameTip + flameH * 0.2 + tipWaver * 0.7,
      width: flameW * 0.65,
      bulgeFactor: 0.6,
    );

    final midPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(cx, flameBase),
        Offset(cx, flameTip + flameH * 0.2),
        [_core, _primary],
      );
    canvas.drawPath(midFlame, midPaint);

    // --- Inner core ---
    final innerFlame = _buildFlamePath(
      cx: cx + sway * 0.4,
      base: flameBase - flameH * 0.1,
      tip: flameTip + flameH * 0.4 + tipWaver * 0.3,
      width: flameW * 0.3,
      bulgeFactor: 0.55,
    );

    final innerPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(cx, flameBase),
        Offset(cx, flameTip + flameH * 0.4),
        [
          _white.withValues(alpha: 0.9),
          _core,
        ],
      );
    canvas.drawPath(innerFlame, innerPaint);

    // Inner core glow
    final innerGlow = Paint()
      ..color = _white.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(innerFlame, innerGlow);

    // --- Base ember glow ---
    final baseGlow = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx + sway, flameBase),
        flameW * 0.8,
        [
          _core.withValues(alpha: 0.3),
          Colors.transparent,
        ],
      );
    canvas.drawCircle(Offset(cx + sway, flameBase), flameW * 0.8, baseGlow);
  }

  Path _buildFlamePath({
    required double cx,
    required double base,
    required double tip,
    required double width,
    required double bulgeFactor,
  }) {
    final h = base - tip;
    return Path()
      ..moveTo(cx, tip)
      // Right curve
      ..cubicTo(
        cx + width * 0.3,
        tip + h * 0.2,
        cx + width,
        tip + h * bulgeFactor,
        cx,
        base,
      )
      // Left curve (mirror)
      ..cubicTo(
        cx - width,
        tip + h * bulgeFactor,
        cx - width * 0.3,
        tip + h * 0.2,
        cx,
        tip,
      )
      ..close();
  }

  @override
  bool shouldRepaint(FlamePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
