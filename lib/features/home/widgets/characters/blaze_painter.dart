import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A multi-point star with radiating lines.
/// Points pulse outward, representing burning bright determination.
class BlazePainter extends CustomPainter {
  BlazePainter({required this.animationValue});

  final double animationValue;

  static const _primary = Color(0xFFFFD700);
  static const _secondary = Color(0xFFFF8C00);
  static const _hot = Color(0xFFFFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final maxR = math.min(cx, cy);
    final t = animationValue * math.pi * 2;

    // Pulse factor
    final pulse = 0.92 + 0.08 * math.sin(t);

    // --- Ambient radial glow ---
    final ambientPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        maxR * 0.95,
        [
          _primary.withValues(alpha: 0.18),
          _secondary.withValues(alpha: 0.06),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawCircle(center, maxR * 0.95, ambientPaint);

    // --- Radiating lines (12 rays) ---
    const rayCount = 12;
    for (var i = 0; i < rayCount; i++) {
      final angle = (i / rayCount) * math.pi * 2 + t * 0.15;
      final rayPhase = (animationValue + i / rayCount) % 1.0;
      final rayLength = maxR * (0.5 + 0.4 * rayPhase) * pulse;
      final rayAlpha = (1.0 - rayPhase) * 0.25;

      final rayStart = Offset(
        cx + math.cos(angle) * maxR * 0.25,
        cy + math.sin(angle) * maxR * 0.25,
      );
      final rayEnd = Offset(
        cx + math.cos(angle) * rayLength,
        cy + math.sin(angle) * rayLength,
      );

      final rayPaint = Paint()
        ..shader = ui.Gradient.linear(
          rayStart,
          rayEnd,
          [
            _primary.withValues(alpha: rayAlpha),
            Colors.transparent,
          ],
        )
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawLine(rayStart, rayEnd, rayPaint);
    }

    // --- Six-pointed star ---
    const points = 6;
    final outerR = maxR * 0.52 * pulse;
    final innerR = maxR * 0.24 * pulse;

    final starPath = Path();
    for (var i = 0; i < points * 2; i++) {
      final angle = (i / (points * 2)) * math.pi * 2 - math.pi / 2;
      final r = i.isEven ? outerR : innerR;
      final px = cx + math.cos(angle) * r;
      final py = cy + math.sin(angle) * r;
      if (i == 0) {
        starPath.moveTo(px, py);
      } else {
        starPath.lineTo(px, py);
      }
    }
    starPath.close();

    // Star outer glow
    final starGlow = Paint()
      ..shader = ui.Gradient.radial(
        center,
        outerR,
        [_primary, _secondary],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawPath(starPath, starGlow);

    // Star body
    final starPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx - outerR * 0.15, cy - outerR * 0.15),
        outerR * 1.2,
        [_primary, _secondary],
      );
    canvas.drawPath(starPath, starPaint);

    // Star edge highlight
    final edgePaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        outerR,
        [
          _hot.withValues(alpha: 0.08),
          _hot.withValues(alpha: 0.15),
        ],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(starPath, edgePaint);

    // --- Center core ---
    final coreR = maxR * 0.14 * pulse;
    final corePaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx - coreR * 0.2, cy - coreR * 0.2),
        coreR * 1.5,
        [_hot, _primary],
      );
    canvas.drawCircle(center, coreR, corePaint);

    // Hot center highlight
    final hotPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        coreR * 0.5,
        [
          _hot.withValues(alpha: 0.8),
          _hot.withValues(alpha: 0.0),
        ],
      );
    canvas.drawCircle(center, coreR * 0.5, hotPaint);

    // --- Pulsing outer ring ---
    final ringPhase = animationValue;
    final ringR = maxR * (0.55 + 0.35 * ringPhase);
    final ringAlpha = (1.0 - ringPhase) * 0.2;
    final ringPaint = Paint()
      ..color = _primary.withValues(alpha: ringAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center, ringR, ringPaint);
  }

  @override
  bool shouldRepaint(BlazePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
