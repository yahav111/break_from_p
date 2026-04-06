import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A central bright circle with 8+ radiating lines that rotate slowly,
/// plus concentric rings pulsing outward. Radiating power and purpose.
class NovaPainter extends CustomPainter {
  NovaPainter({required this.animationValue});

  final double animationValue;

  static const _primary = Color(0xFF7B61FF);
  static const _secondary = Color(0xFF4ECBFF);
  static const _white = Color(0xFFFFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final maxR = math.min(cx, cy);
    final t = animationValue * math.pi * 2;

    // --- Pulsing concentric rings ---
    for (var i = 0; i < 3; i++) {
      final ringPhase = (animationValue + i * 0.33) % 1.0;
      final ringR = maxR * (0.3 + 0.65 * ringPhase);
      final ringAlpha = (1.0 - ringPhase) * 0.2;

      final ringPaint = Paint()
        ..shader = ui.Gradient.sweep(
          center,
          [
            _primary.withValues(alpha: ringAlpha),
            _secondary.withValues(alpha: ringAlpha * 0.7),
            _primary.withValues(alpha: ringAlpha),
          ],
          [0.0, 0.5, 1.0],
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(center, ringR, ringPaint);
    }

    // --- Radiating rays (10 rays, rotating) ---
    const rayCount = 10;
    final rotation = t * 0.3; // Slow rotation

    for (var i = 0; i < rayCount; i++) {
      final angle = (i / rayCount) * math.pi * 2 + rotation;
      // Alternate long and short rays
      final isLong = i.isEven;
      final rayLength = maxR * (isLong ? 0.88 : 0.65);
      final rayWidth = isLong ? 2.5 : 1.5;

      // Pulse each ray slightly
      final rayPulse = 0.85 + 0.15 * math.sin(t * 2 + i * 0.6);
      final actualLength = rayLength * rayPulse;

      final startR = maxR * 0.18;
      final rayStart = Offset(
        cx + math.cos(angle) * startR,
        cy + math.sin(angle) * startR,
      );
      final rayEnd = Offset(
        cx + math.cos(angle) * actualLength,
        cy + math.sin(angle) * actualLength,
      );

      // Ray gradient from primary to secondary
      final rayPaint = Paint()
        ..shader = ui.Gradient.linear(
          rayStart,
          rayEnd,
          [
            _white.withValues(alpha: 0.5),
            isLong ? _secondary.withValues(alpha: 0.3) : _primary.withValues(alpha: 0.25),
            Colors.transparent,
          ],
          [0.0, 0.5, 1.0],
        )
        ..strokeWidth = rayWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawLine(rayStart, rayEnd, rayPaint);

      // Ray glow
      final rayGlow = Paint()
        ..shader = ui.Gradient.linear(
          rayStart,
          rayEnd,
          [
            (isLong ? _secondary : _primary).withValues(alpha: 0.15),
            Colors.transparent,
          ],
        )
        ..strokeWidth = rayWidth * 3
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawLine(rayStart, rayEnd, rayGlow);
    }

    // --- Mid glow halo ---
    final haloPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        maxR * 0.45,
        [
          _secondary.withValues(alpha: 0.12),
          _primary.withValues(alpha: 0.06),
          Colors.transparent,
        ],
        [0.0, 0.6, 1.0],
      );
    canvas.drawCircle(center, maxR * 0.45, haloPaint);

    // --- Core orb ---
    final coreR = maxR * 0.18;

    // Outer core glow
    final coreGlow = Paint()
      ..shader = ui.Gradient.radial(
        center,
        coreR * 2.5,
        [
          _primary.withValues(alpha: 0.3),
          _secondary.withValues(alpha: 0.1),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, coreR * 2.5, coreGlow);

    // Core gradient
    final corePaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx - coreR * 0.2, cy - coreR * 0.2),
        coreR * 1.5,
        [
          _white.withValues(alpha: 0.9),
          _secondary,
          _primary,
        ],
        [0.0, 0.4, 1.0],
      );
    canvas.drawCircle(center, coreR, corePaint);

    // Core hot center
    final hotPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx - coreR * 0.1, cy - coreR * 0.1),
        coreR * 0.5,
        [
          _white.withValues(alpha: 0.9),
          _white.withValues(alpha: 0.0),
        ],
      );
    canvas.drawCircle(center, coreR * 0.4, hotPaint);

    // --- Orbiting sparks ---
    for (var i = 0; i < 4; i++) {
      final orbitAngle = t * 0.8 + (i / 4) * math.pi * 2;
      final orbitR = maxR * (0.32 + 0.06 * math.sin(t * 2 + i));
      final sparkPos = Offset(
        cx + math.cos(orbitAngle) * orbitR,
        cy + math.sin(orbitAngle) * orbitR,
      );
      final sparkR = maxR * 0.025;

      final sparkPaint = Paint()
        ..color = (i.isEven ? _secondary : _primary).withValues(alpha: 0.7)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(sparkPos, sparkR, sparkPaint);

      final sparkCore = Paint()
        ..color = _white.withValues(alpha: 0.8);
      canvas.drawCircle(sparkPos, sparkR * 0.4, sparkCore);
    }
  }

  @override
  bool shouldRepaint(NovaPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
