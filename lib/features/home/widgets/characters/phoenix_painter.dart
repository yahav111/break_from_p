import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A bird silhouette with arcs and bezier curves -- two wing arcs
/// spreading from a center body. Wings spread and contract with animation.
/// Represents rebirth and transformation.
class PhoenixPainter extends CustomPainter {
  PhoenixPainter({required this.animationValue});

  final double animationValue;

  static const _primary = Color(0xFFFF6EC7);
  static const _secondary = Color(0xFFBE3FD8);
  static const _hot = Color(0xFFFFFFFF);
  static const _glow = Color(0xFFFF9FDB);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final maxR = math.min(cx, cy);
    final t = animationValue * math.pi * 2;

    // Wing spread: 0.85 - 1.0
    final wingSpread = 0.85 + 0.15 * math.sin(t);
    // Gentle body bob
    final bob = math.sin(t * 1.5) * maxR * 0.02;

    final bodyY = cy + bob;

    // --- Ambient glow ---
    final ambientPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx, bodyY),
        maxR * 0.9,
        [
          _primary.withValues(alpha: 0.15),
          _secondary.withValues(alpha: 0.05),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawCircle(Offset(cx, bodyY), maxR * 0.9, ambientPaint);

    // --- Trail feathers (emanating downward) ---
    for (var i = 0; i < 3; i++) {
      final featherPhase = (animationValue + i * 0.3) % 1.0;
      final featherY = bodyY + maxR * 0.2 + featherPhase * maxR * 0.6;
      final featherAlpha = (1.0 - featherPhase) * 0.25;
      final featherSpread = maxR * 0.08 * (1.0 - featherPhase * 0.5);

      final featherPaint = Paint()
        ..color = _secondary.withValues(alpha: featherAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, featherY),
          width: featherSpread * 2,
          height: featherSpread * 0.5,
        ),
        featherPaint,
      );
    }

    // --- Wings ---
    final wingW = maxR * 0.82 * wingSpread;
    final wingH = maxR * 0.5;
    final wingTipY = bodyY - wingH * 0.7;

    // Right wing
    final rightWing = Path()
      ..moveTo(cx + maxR * 0.05, bodyY)
      ..cubicTo(
        cx + wingW * 0.4,
        bodyY - wingH * 0.2,
        cx + wingW * 0.85,
        wingTipY - wingH * 0.1,
        cx + wingW,
        wingTipY,
      )
      // Wing tip curve
      ..cubicTo(
        cx + wingW * 0.9,
        wingTipY + wingH * 0.15,
        cx + wingW * 0.6,
        bodyY - wingH * 0.05,
        cx + maxR * 0.08,
        bodyY + maxR * 0.12,
      )
      ..close();

    // Left wing (mirror)
    final leftWing = Path()
      ..moveTo(cx - maxR * 0.05, bodyY)
      ..cubicTo(
        cx - wingW * 0.4,
        bodyY - wingH * 0.2,
        cx - wingW * 0.85,
        wingTipY - wingH * 0.1,
        cx - wingW,
        wingTipY,
      )
      ..cubicTo(
        cx - wingW * 0.9,
        wingTipY + wingH * 0.15,
        cx - wingW * 0.6,
        bodyY - wingH * 0.05,
        cx - maxR * 0.08,
        bodyY + maxR * 0.12,
      )
      ..close();

    // Wing glow
    final wingGlowPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx, bodyY),
        wingW,
        [
          _primary.withValues(alpha: 0.2),
          _secondary.withValues(alpha: 0.1),
        ],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawPath(rightWing, wingGlowPaint);
    canvas.drawPath(leftWing, wingGlowPaint);

    // Wing fill
    final wingPaintR = Paint()
      ..shader = ui.Gradient.linear(
        Offset(cx, bodyY),
        Offset(cx + wingW, wingTipY),
        [_secondary, _primary, _glow.withValues(alpha: 0.6)],
        [0.0, 0.6, 1.0],
      );
    canvas.drawPath(rightWing, wingPaintR);

    final wingPaintL = Paint()
      ..shader = ui.Gradient.linear(
        Offset(cx, bodyY),
        Offset(cx - wingW, wingTipY),
        [_secondary, _primary, _glow.withValues(alpha: 0.6)],
        [0.0, 0.6, 1.0],
      );
    canvas.drawPath(leftWing, wingPaintL);

    // Wing edge shimmer
    final shimmerPaint = Paint()
      ..color = _hot.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawPath(rightWing, shimmerPaint);
    canvas.drawPath(leftWing, shimmerPaint);

    // --- Body ---
    final bodyR = maxR * 0.13;
    final bodyPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx - bodyR * 0.2, bodyY - bodyR * 0.3),
        bodyR * 2,
        [_glow, _primary, _secondary],
        [0.0, 0.4, 1.0],
      );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, bodyY),
        width: bodyR * 2,
        height: bodyR * 2.6,
      ),
      bodyPaint,
    );

    // Body glow
    final bodyGlow = Paint()
      ..shader = ui.Gradient.radial(
        center,
        bodyR * 2,
        [
          _hot.withValues(alpha: 0.2),
          Colors.transparent,
        ],
      );
    canvas.drawCircle(Offset(cx, bodyY), bodyR * 2, bodyGlow);

    // --- Head ---
    final headY = bodyY - bodyR * 1.8;
    final headR = bodyR * 0.6;
    final headPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx, headY),
        headR * 1.5,
        [_glow, _primary],
      );
    canvas.drawCircle(Offset(cx, headY), headR, headPaint);

    // Head bright spot
    final headHighlight = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx - headR * 0.2, headY - headR * 0.2),
        headR * 0.5,
        [
          _hot.withValues(alpha: 0.6),
          _hot.withValues(alpha: 0.0),
        ],
      );
    canvas.drawCircle(Offset(cx, headY), headR * 0.4, headHighlight);
  }

  @override
  bool shouldRepaint(PhoenixPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
