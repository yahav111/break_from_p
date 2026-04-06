import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A spiral galaxy with dots along spiral arms, slow rotation,
/// central bright core with cross-shaped lens flare.
/// The ultimate transcendent form.
class CosmosPainter extends CustomPainter {
  CosmosPainter({required this.animationValue});

  final double animationValue;

  static const _primary = Color(0xFFFFFFFF);
  static const _secondary = Color(0xFFD0D8FF);
  static const _accent1 = Color(0xFF7B61FF);
  static const _accent2 = Color(0xFF4ECBFF);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final maxR = math.min(cx, cy);
    final t = animationValue * math.pi * 2;

    // Galaxy rotation
    final rotation = t * 0.2;

    // --- Deep glow background ---
    final bgGlow = Paint()
      ..shader = ui.Gradient.radial(
        center,
        maxR * 0.95,
        [
          _accent1.withValues(alpha: 0.08),
          _accent2.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawCircle(center, maxR * 0.95, bgGlow);

    // --- Spiral arms ---
    // Two main spiral arms
    for (var arm = 0; arm < 2; arm++) {
      final armOffset = arm * math.pi;

      // Draw dots along the spiral arm
      const dotsPerArm = 40;
      for (var i = 0; i < dotsPerArm; i++) {
        final progress = i / dotsPerArm;
        // Logarithmic spiral: r = a * e^(b * theta)
        final theta = progress * math.pi * 3 + armOffset + rotation;
        final r = maxR * 0.08 + maxR * 0.75 * progress;

        final dotX = cx + math.cos(theta) * r;
        final dotY = cy + math.sin(theta) * r;

        // Dot properties: brighter near center, bigger near middle
        final sizeFactor = progress < 0.5
            ? 0.5 + progress
            : 1.5 - progress;
        final dotR = maxR * 0.015 * sizeFactor;
        final dotAlpha = (1.0 - progress * 0.7) * 0.7;

        // Alternate colors along arm
        final dotColor = i % 3 == 0
            ? _accent2
            : i % 3 == 1
                ? _secondary
                : _accent1;

        final dotPaint = Paint()
          ..color = dotColor.withValues(alpha: dotAlpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
        canvas.drawCircle(Offset(dotX, dotY), dotR, dotPaint);

        // Bright core for some dots
        if (i % 4 == 0) {
          final corePaint = Paint()
            ..color = _primary.withValues(alpha: dotAlpha * 0.8);
          canvas.drawCircle(Offset(dotX, dotY), dotR * 0.4, corePaint);
        }
      }
    }

    // --- Faint spiral arm glow (painted as arcs) ---
    for (var arm = 0; arm < 2; arm++) {
      final armOffset = arm * math.pi;
      final armPath = Path();

      const segments = 60;
      for (var i = 0; i <= segments; i++) {
        final progress = i / segments;
        final theta = progress * math.pi * 3 + armOffset + rotation;
        final r = maxR * 0.08 + maxR * 0.75 * progress;
        final px = cx + math.cos(theta) * r;
        final py = cy + math.sin(theta) * r;
        if (i == 0) {
          armPath.moveTo(px, py);
        } else {
          armPath.lineTo(px, py);
        }
      }

      final armPaint = Paint()
        ..color = _secondary.withValues(alpha: 0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = maxR * 0.12
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawPath(armPath, armPaint);
    }

    // --- Central core glow ---
    final coreOuterGlow = Paint()
      ..shader = ui.Gradient.radial(
        center,
        maxR * 0.35,
        [
          _primary.withValues(alpha: 0.3),
          _secondary.withValues(alpha: 0.12),
          _accent1.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        [0.0, 0.3, 0.6, 1.0],
      );
    canvas.drawCircle(center, maxR * 0.35, coreOuterGlow);

    // --- Cross-shaped lens flare ---
    final flareLength = maxR * (0.55 + 0.08 * math.sin(t * 1.5));
    final flareWidth = maxR * 0.025;

    // Vertical flare
    final vFlare = Paint()
      ..shader = ui.Gradient.linear(
        Offset(cx, cy - flareLength),
        Offset(cx, cy + flareLength),
        [
          Colors.transparent,
          _primary.withValues(alpha: 0.15),
          _primary.withValues(alpha: 0.4),
          _primary.withValues(alpha: 0.15),
          Colors.transparent,
        ],
        [0.0, 0.3, 0.5, 0.7, 1.0],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawRect(
      Rect.fromCenter(center: center, width: flareWidth, height: flareLength * 2),
      vFlare,
    );

    // Horizontal flare
    final hFlare = Paint()
      ..shader = ui.Gradient.linear(
        Offset(cx - flareLength, cy),
        Offset(cx + flareLength, cy),
        [
          Colors.transparent,
          _primary.withValues(alpha: 0.15),
          _primary.withValues(alpha: 0.4),
          _primary.withValues(alpha: 0.15),
          Colors.transparent,
        ],
        [0.0, 0.3, 0.5, 0.7, 1.0],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawRect(
      Rect.fromCenter(center: center, width: flareLength * 2, height: flareWidth),
      hFlare,
    );

    // Diagonal flares (45 degree, fainter)
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(math.pi / 4);
    canvas.translate(-cx, -cy);

    final diagLength = flareLength * 0.6;
    final dFlare = Paint()
      ..shader = ui.Gradient.linear(
        Offset(cx, cy - diagLength),
        Offset(cx, cy + diagLength),
        [
          Colors.transparent,
          _secondary.withValues(alpha: 0.08),
          _secondary.withValues(alpha: 0.2),
          _secondary.withValues(alpha: 0.08),
          Colors.transparent,
        ],
        [0.0, 0.3, 0.5, 0.7, 1.0],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawRect(
      Rect.fromCenter(center: center, width: flareWidth * 0.7, height: diagLength * 2),
      dFlare,
    );
    canvas.drawRect(
      Rect.fromCenter(center: center, width: diagLength * 2, height: flareWidth * 0.7),
      dFlare,
    );
    canvas.restore();

    // --- Core orb ---
    final coreR = maxR * 0.1;
    final corePaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx - coreR * 0.15, cy - coreR * 0.15),
        coreR * 1.5,
        [_primary, _secondary, _accent1],
        [0.0, 0.5, 1.0],
      );
    canvas.drawCircle(center, coreR, corePaint);

    // Core white hot center
    final hotPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        coreR * 0.6,
        [
          _primary.withValues(alpha: 0.95),
          _primary.withValues(alpha: 0.0),
        ],
      );
    canvas.drawCircle(center, coreR * 0.6, hotPaint);

    // --- Scattered distant stars ---
    final rng = math.Random(42);
    for (var i = 0; i < 12; i++) {
      final starAngle = rng.nextDouble() * math.pi * 2;
      final starDist = maxR * (0.5 + rng.nextDouble() * 0.4);
      final starX = cx + math.cos(starAngle + rotation * 0.1) * starDist;
      final starY = cy + math.sin(starAngle + rotation * 0.1) * starDist;
      final twinkle = 0.3 + 0.7 * ((math.sin(t * 3 + i * 1.2) + 1) / 2);
      final starR = maxR * 0.008 * (0.5 + rng.nextDouble());

      final starPaint = Paint()
        ..color = _primary.withValues(alpha: 0.5 * twinkle);
      canvas.drawCircle(Offset(starX, starY), starR, starPaint);
    }
  }

  @override
  bool shouldRepaint(CosmosPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
