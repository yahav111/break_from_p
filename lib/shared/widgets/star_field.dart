import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';

/// A small star field painted deterministically (no Random → no rebuilds).
class StarField extends StatelessWidget {
  const StarField({super.key, this.density = 40});

  final int density;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarPainter(density: density),
    );
  }
}

class _StarPainter extends CustomPainter {
  _StarPainter({required this.density});

  final int density;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < density; i++) {
      final x = (i * 173.0 + 47) % size.width;
      final y = (i * 97.0 + 23) % size.height;
      final r = ((i * 7) % 3 == 0) ? 1.5 : 0.8;
      final opacity = 0.3 + (i % 5) * 0.12;
      paint.color = AppColors.starHighlight.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) => old.density != density;
}
