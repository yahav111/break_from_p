import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/services/lifetree_engine.dart';
import '../../../design_system/tokens/app_colors.dart';

/// Category colors for each Lifetree branch.
const _categoryColors = <LifetreeCategory, Color>{
  LifetreeCategory.breathing: Color(0xFF4ECB71),
  LifetreeCategory.journaling: Color(0xFF7B61FF),
  LifetreeCategory.meditation: Color(0xFF4ECBFF),
  LifetreeCategory.soundscapes: Color(0xFFFF9F43),
};

/// Constellation-themed canvas that renders Lifetree nodes and connections.
class LifetreeCanvas extends StatelessWidget {
  const LifetreeCanvas({
    super.key,
    required this.unlockedNodeIds,
    required this.streakDays,
    required this.exerciseCount,
    required this.journalEntries,
    this.onNodeTap,
  });

  final Set<String> unlockedNodeIds;
  final int streakDays;
  final int exerciseCount;
  final int journalEntries;
  final void Function(LifetreeNode node)? onNodeTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapUp: (details) => _handleTap(details, constraints.biggest),
          child: CustomPaint(
            size: constraints.biggest,
            painter: _LifetreeCanvasPainter(
              unlockedNodeIds: unlockedNodeIds,
              streakDays: streakDays,
              exerciseCount: exerciseCount,
              journalEntries: journalEntries,
            ),
          ),
        );
      },
    );
  }

  void _handleTap(TapUpDetails details, Size canvasSize) {
    if (onNodeTap == null) return;

    final tapPos = details.localPosition;
    const hitRadius = 30.0;

    for (final node in LifetreeEngine.nodes) {
      final nodeCenter = Offset(
        node.position.dx * canvasSize.width,
        node.position.dy * canvasSize.height,
      );
      if ((tapPos - nodeCenter).distance <= hitRadius) {
        onNodeTap!(node);
        return;
      }
    }
  }
}

/// The node's visual state on the canvas.
enum _NodeState { unlocked, unlockable, locked, comingSoon }

class _LifetreeCanvasPainter extends CustomPainter {
  _LifetreeCanvasPainter({
    required this.unlockedNodeIds,
    required this.streakDays,
    required this.exerciseCount,
    required this.journalEntries,
  });

  final Set<String> unlockedNodeIds;
  final int streakDays;
  final int exerciseCount;
  final int journalEntries;

  static const _nodeRadius = 22.0;

  _NodeState _stateOf(LifetreeNode node) {
    if (node.isComingSoon) return _NodeState.comingSoon;
    if (unlockedNodeIds.contains(node.id)) return _NodeState.unlocked;
    if (LifetreeEngine.isUnlockable(
      node,
      streakDays: streakDays,
      exercises: exerciseCount,
      journalEntries: journalEntries,
    )) {
      return _NodeState.unlockable;
    }
    return _NodeState.locked;
  }

  Offset _screenPos(LifetreeNode node, Size size) {
    return Offset(
      node.position.dx * size.width,
      node.position.dy * size.height,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawStars(canvas, size);
    _drawConnections(canvas, size);
    _drawNodes(canvas, size);
    _drawLabels(canvas, size);
  }

  // ── Background stars ──────────────────────────────────────────────

  void _drawStars(Canvas canvas, Size size) {
    final rng = Random(42);
    final paint = Paint();

    for (var i = 0; i < 35; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final radius = 0.5 + rng.nextDouble() * 1.5;
      final alpha = (0.1 + rng.nextDouble() * 0.2) * 255;
      paint.color = Colors.white.withAlpha(alpha.toInt());
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  // ── Constellation lines ───────────────────────────────────────────

  void _drawConnections(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

    for (final (idA, idB) in LifetreeEngine.connections) {
      final nodeA = LifetreeEngine.nodeById(idA);
      final nodeB = LifetreeEngine.nodeById(idB);
      if (nodeA == null || nodeB == null) continue;

      final bothUnlocked =
          unlockedNodeIds.contains(idA) && unlockedNodeIds.contains(idB);

      linePaint.color = bothUnlocked
          ? AppColors.primary.withAlpha(102) // 0.4
          : Colors.white.withAlpha(20); // 0.08

      canvas.drawLine(
        _screenPos(nodeA, size),
        _screenPos(nodeB, size),
        linePaint,
      );
    }
  }

  // ── Nodes ─────────────────────────────────────────────────────────

  void _drawNodes(Canvas canvas, Size size) {
    for (final node in LifetreeEngine.nodes) {
      final center = _screenPos(node, size);
      final state = _stateOf(node);
      final catColor = _categoryColors[node.category] ?? AppColors.primary;

      switch (state) {
        case _NodeState.unlocked:
          _drawUnlockedNode(canvas, center, catColor, node);
        case _NodeState.unlockable:
          _drawUnlockableNode(canvas, center, catColor);
        case _NodeState.locked:
          _drawLockedNode(canvas, center);
        case _NodeState.comingSoon:
          _drawComingSoonNode(canvas, center);
      }
    }
  }

  void _drawUnlockedNode(
    Canvas canvas,
    Offset center,
    Color color,
    LifetreeNode node,
  ) {
    // Glow shadow.
    canvas.drawCircle(
      center,
      _nodeRadius + 6,
      Paint()..color = color.withAlpha(51), // 0.2
    );

    // Gradient fill.
    final gradientPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        _nodeRadius,
        [color, color.withAlpha(178)], // 100% -> 70%
      );
    canvas.drawCircle(center, _nodeRadius, gradientPaint);

    // Icon (category-based).
    final iconData = _iconForCategory(node.category);
    _drawIcon(canvas, center, iconData, Colors.white);
  }

  void _drawUnlockableNode(Canvas canvas, Offset center, Color color) {
    // Pulsing border ring (slightly larger circle).
    canvas.drawCircle(
      center,
      _nodeRadius + 3,
      Paint()
        ..color = color.withAlpha(76) // 0.3
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Filled circle at reduced alpha.
    canvas.drawCircle(
      center,
      _nodeRadius,
      Paint()..color = color.withAlpha(128), // 0.5
    );

    // Star icon to indicate "ready".
    _drawIcon(canvas, center, Icons.star_rounded, Colors.white.withAlpha(204));
  }

  void _drawLockedNode(Canvas canvas, Offset center) {
    // Dark filled circle.
    canvas.drawCircle(
      center,
      _nodeRadius,
      Paint()..color = AppColors.darkCard,
    );

    // Faint border.
    canvas.drawCircle(
      center,
      _nodeRadius,
      Paint()
        ..color = Colors.white.withAlpha(20) // 0.08
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Lock icon.
    _drawIcon(
      canvas,
      center,
      Icons.lock_rounded,
      Colors.white.withAlpha(76),
    );
  }

  void _drawComingSoonNode(Canvas canvas, Offset center) {
    // Dashed circle via arc segments.
    const segments = 12;
    const gapAngle = pi / 36; // small gap between dashes
    const sweepAngle = (2 * pi / segments) - gapAngle;

    final dashPaint = Paint()
      ..color = Colors.white.withAlpha(38) // 0.15
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (var i = 0; i < segments; i++) {
      final startAngle = i * (2 * pi / segments);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: _nodeRadius),
        startAngle,
        sweepAngle,
        false,
        dashPaint,
      );
    }

    // "?" label.
    final tp = TextPainter(
      text: TextSpan(
        text: '?',
        style: TextStyle(
          color: Colors.white.withAlpha(76),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  // ── Node labels ───────────────────────────────────────────────────

  void _drawLabels(Canvas canvas, Size size) {
    for (final node in LifetreeEngine.nodes) {
      final center = _screenPos(node, size);
      final tp = TextPainter(
        text: TextSpan(
          text: node.title,
          style: TextStyle(
            color: Colors.white.withAlpha(178), // 0.7
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 100);
      tp.paint(
        canvas,
        Offset(center.dx - tp.width / 2, center.dy + _nodeRadius + 6),
      );
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────

  IconData _iconForCategory(LifetreeCategory category) {
    switch (category) {
      case LifetreeCategory.breathing:
        return Icons.air_rounded;
      case LifetreeCategory.journaling:
        return Icons.edit_note_rounded;
      case LifetreeCategory.meditation:
        return Icons.self_improvement_rounded;
      case LifetreeCategory.soundscapes:
        return Icons.music_note_rounded;
    }
  }

  /// Draws a Material icon glyph on the canvas using TextPainter.
  void _drawIcon(
    Canvas canvas,
    Offset center,
    IconData icon,
    Color color,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 20,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _LifetreeCanvasPainter oldDelegate) {
    return oldDelegate.unlockedNodeIds != unlockedNodeIds ||
        oldDelegate.streakDays != streakDays ||
        oldDelegate.exerciseCount != exerciseCount ||
        oldDelegate.journalEntries != journalEntries;
  }
}
