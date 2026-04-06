import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/models/character_stage.dart';
import '../../../design_system/design_system.dart';
import 'orb_detail_dialog.dart';

/// Grade definitions — milestone days with progressively more impressive visuals.
class _Grade {
  const _Grade(this.day, this.label, {this.milestoneTitle, this.characterStage});
  final int day;
  final String label;
  final String? milestoneTitle;
  final CharacterStage? characterStage;
}

const _grades = [
  _Grade(0, 'Start'),
  _Grade(1, 'Day 1'),
  _Grade(3, 'Day 3'),
  _Grade(7, '1 Week'),
  _Grade(14, '2 Weeks'),
  _Grade(21, '3 Weeks'),
  _Grade(30, '1 Month', milestoneTitle: 'True Freedom', characterStage: CharacterStage.phoenix),
  _Grade(45, '45 Days'),
  _Grade(60, '2 Months', milestoneTitle: 'Master of Control', characterStage: CharacterStage.nova),
  _Grade(90, '3 Months', milestoneTitle: 'Hero of Light', characterStage: CharacterStage.cosmos),
  _Grade(120, '4 Months'),
  _Grade(150, '5 Months'),
  _Grade(180, '6 Months'),
  _Grade(270, '9 Months'),
  _Grade(365, '1 Year'),
  _Grade(500, '500 Days'),
  _Grade(730, '2 Years'),
];

/// Carousel of grade orbs with snap-to-center and scale effect.
/// The centered orb is large, orbs further away shrink.
class DayOrbsRow extends StatefulWidget {
  const DayOrbsRow({super.key, required this.days});

  final int days;

  @override
  State<DayOrbsRow> createState() => _DayOrbsRowState();
}

class _DayOrbsRowState extends State<DayOrbsRow>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _pulseController;
  double _currentPage = 0;

  // The centered orb is this big; orbs at ±1 page away shrink to _minScale.
  static const double _maxOrbSize = 120.0;
  static const double _minScale = 0.55;
  static const double _rowHeight = _maxOrbSize + 40; // orb + label + glow room

  @override
  void initState() {
    super.initState();
    final startPage = _currentIndex.toDouble();
    _currentPage = startPage;
    _pageController = PageController(
      viewportFraction: 0.35,
      initialPage: _currentIndex,
    );
    _pageController.addListener(() {
      setState(() => _currentPage = _pageController.page ?? _currentPage);
    });
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(DayOrbsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.days != widget.days) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  int get _currentIndex {
    var idx = 0;
    for (var i = 0; i < _grades.length; i++) {
      if (_grades[i].day <= widget.days) idx = i;
    }
    return idx;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _rowHeight,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _grades.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final grade = _grades[index];
          final isLocked = grade.day > widget.days;

          // Distance from center in pages (fractional).
          final distance = (index - _currentPage).abs();
          // Scale: 1.0 at center, shrinks toward _minScale.
          final scale = math.max(_minScale, 1.0 - distance * 0.3);

          return Center(
            child: Transform.scale(
              scale: scale,
              child: _GradeOrb(
                grade: grade,
                isLocked: isLocked,
                size: _maxOrbSize,
                currentDays: widget.days,
                pulseAnimation:
                    (index == _currentIndex && distance < 0.5) ? _pulseController : null,
                onTap: () => OrbDetailDialog.show(
                  context,
                  day: grade.day,
                  label: grade.label,
                  isLocked: isLocked,
                  currentDays: widget.days,
                  milestoneTitle: grade.milestoneTitle,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Visual tier configuration for grade orbs.
class _OrbTier {
  const _OrbTier({
    required this.colors,
    required this.innerHighlight,
    this.glowColor,
    this.glowRadius = 0,
    this.ringColors,
    this.hasDoubleRing = false,
  });

  final List<Color> colors;
  final Color innerHighlight;
  final Color? glowColor;
  final double glowRadius;
  final List<Color>? ringColors;
  final bool hasDoubleRing;
}

class _GradeOrb extends StatelessWidget {
  const _GradeOrb({
    required this.grade,
    required this.isLocked,
    required this.size,
    required this.currentDays,
    this.pulseAnimation,
    this.onTap,
  });

  final _Grade grade;
  final bool isLocked;
  final double size;
  final int currentDays;
  final AnimationController? pulseAnimation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tier = _tierForDay(grade.day);

    Widget orb = _buildOrb(tier);

    // Pulse glow on the user's current grade.
    if (pulseAnimation != null) {
      orb = AnimatedBuilder(
        animation: pulseAnimation!,
        builder: (context, child) {
          final pulse = pulseAnimation!.value;
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                if (tier.glowRadius > 0)
                  BoxShadow(
                    color: (tier.glowColor ?? tier.colors.first)
                        .withValues(alpha: 0.3 + pulse * 0.25),
                    blurRadius: tier.glowRadius + pulse * 10,
                    spreadRadius: tier.glowRadius * 0.15 + pulse * 4,
                  ),
              ],
            ),
            child: child,
          );
        },
        child: _buildOrb(tier),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          orb,
          const SizedBox(height: 6),
          Text(
            grade.label,
            style: AppTypography.caption.copyWith(
              fontSize: 10,
              color: isLocked
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.8),
              fontWeight: AppTypography.medium,
            ),
          ),
          if (grade.milestoneTitle != null && !isLocked) ...[
            const SizedBox(height: 2),
            Text(
              grade.milestoneTitle!,
              style: AppTypography.caption.copyWith(
                fontSize: 8,
                color: AppColors.primary,
                fontWeight: AppTypography.semiBold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrb(_OrbTier tier) {
    final hasRing = tier.ringColors != null;

    List<Color> orbColors;
    if (isLocked) {
      orbColors = tier.colors
          .map((c) => Color.lerp(c, const Color(0xFF0A0A18), 0.65)!)
          .toList();
    } else {
      orbColors = tier.colors;
    }

    final innerSize = hasRing ? size - 10 : size;

    Widget inner = Container(
      width: innerSize,
      height: innerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.85,
          colors: [
            if (!isLocked) tier.innerHighlight.withValues(alpha: 0.7),
            ...orbColors,
          ],
        ),
        boxShadow: [
          if (!isLocked)
            BoxShadow(
              color: orbColors.first.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          if (tier.glowRadius > 0 && pulseAnimation == null)
            BoxShadow(
              color: (tier.glowColor ?? tier.colors.first)
                  .withValues(alpha: isLocked ? 0.08 : 0.4),
              blurRadius: isLocked ? tier.glowRadius * 0.4 : tier.glowRadius,
              spreadRadius: isLocked ? 0 : tier.glowRadius * 0.15,
            ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glass-like specular highlight
          if (!isLocked)
            Positioned(
              top: innerSize * 0.1,
              child: Container(
                width: innerSize * 0.45,
                height: innerSize * 0.22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(innerSize),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.4),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          // Day number or lock icon
          if (isLocked)
            Icon(
              Icons.lock_rounded,
              color: (tier.ringColors?.first ?? tier.colors.first)
                  .withValues(alpha: 0.3),
              size: innerSize * 0.3,
            )
          else
            Text(
              '${grade.day}',
              style: AppTypography.caption.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
                fontSize: 20,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    // Gradient sweep ring
    if (hasRing) {
      final ringColors = isLocked
          ? tier.ringColors!
              .map((c) => Color.lerp(c, const Color(0xFF0A0A18), 0.7)!)
              .toList()
          : tier.ringColors!;

      inner = CustomPaint(
        painter: _RingPainter(
          colors: ringColors,
          strokeWidth: tier.hasDoubleRing ? 3.5 : 3.0,
          hasDoubleRing: tier.hasDoubleRing && !isLocked,
        ),
        child: Center(child: inner),
      );
      inner = SizedBox(width: size, height: size, child: inner);
    }

    return inner;
  }

  static _OrbTier _tierForDay(int day) {
    if (day == 0) {
      return const _OrbTier(
        colors: [Color(0xFF2E2850), Color(0xFF1A1535), Color(0xFF0F0D20)],
        innerHighlight: Color(0xFF4A3F70),
      );
    }
    if (day <= 1) {
      return const _OrbTier(
        colors: [Color(0xFF4A3580), Color(0xFF2E2060), Color(0xFF1A1540)],
        innerHighlight: Color(0xFF7060B0),
        glowColor: Color(0x447B61FF),
        glowRadius: 8,
      );
    }
    if (day <= 3) {
      return const _OrbTier(
        colors: [Color(0xFF5B3EDD), Color(0xFF3A25A0), Color(0xFF221570)],
        innerHighlight: Color(0xFF9B80FF),
        glowColor: Color(0x557B61FF),
        glowRadius: 12,
        ringColors: [Color(0xFF5B3EDD), Color(0xFF3A25A0)],
      );
    }
    if (day <= 7) {
      return const _OrbTier(
        colors: [Color(0xFF7B61FF), Color(0xFF5B3EDD), Color(0xFF3018A0)],
        innerHighlight: Color(0xFFBDA8FF),
        glowColor: Color(0x667B61FF),
        glowRadius: 16,
        ringColors: [Color(0xFF9B86FF), Color(0xFF5B3EDD), Color(0xFF9B86FF)],
      );
    }
    if (day <= 14) {
      return const _OrbTier(
        colors: [Color(0xFF9B4DDB), Color(0xFF7B61FF), Color(0xFF4020C0)],
        innerHighlight: Color(0xFFD0B8FF),
        glowColor: Color(0x779B4DDB),
        glowRadius: 20,
        ringColors: [Color(0xFFBE3FD8), Color(0xFF7B61FF), Color(0xFFBE3FD8)],
        hasDoubleRing: true,
      );
    }
    if (day <= 21) {
      return const _OrbTier(
        colors: [Color(0xFFBE3FD8), Color(0xFF9B4DDB), Color(0xFF5B30BB)],
        innerHighlight: Color(0xFFE88FEF),
        glowColor: Color(0x88BE3FD8),
        glowRadius: 22,
        ringColors: [Color(0xFFE060E8), Color(0xFFBE3FD8), Color(0xFF9B4DDB), Color(0xFFE060E8)],
        hasDoubleRing: true,
      );
    }
    if (day <= 30) {
      return const _OrbTier(
        colors: [Color(0xFFFF6EC7), Color(0xFFBE3FD8), Color(0xFF7B40C0)],
        innerHighlight: Color(0xFFFFB0E0),
        glowColor: Color(0x99FF6EC7),
        glowRadius: 24,
        ringColors: [Color(0xFFFF8ED7), Color(0xFFFF6EC7), Color(0xFFBE3FD8), Color(0xFFFF8ED7)],
        hasDoubleRing: true,
      );
    }
    if (day <= 45) {
      return const _OrbTier(
        colors: [Color(0xFFFF7B5C), Color(0xFFFF5070), Color(0xFFBE3FD8)],
        innerHighlight: Color(0xFFFFB8A8),
        glowColor: Color(0x99FF7B5C),
        glowRadius: 26,
        ringColors: [Color(0xFFFF9B7C), Color(0xFFFF5070), Color(0xFFFF7B5C), Color(0xFFFF9B7C)],
        hasDoubleRing: true,
      );
    }
    if (day <= 60) {
      return const _OrbTier(
        colors: [Color(0xFFFFB020), Color(0xFFFF8C20), Color(0xFFE05020)],
        innerHighlight: Color(0xFFFFE0A0),
        glowColor: Color(0xAAFFB020),
        glowRadius: 28,
        ringColors: [Color(0xFFFFD060), Color(0xFFFFB020), Color(0xFFFF8C20), Color(0xFFFFD060)],
        hasDoubleRing: true,
      );
    }
    if (day <= 90) {
      return const _OrbTier(
        colors: [Color(0xFFFFD700), Color(0xFFFFB020), Color(0xFFE89020)],
        innerHighlight: Color(0xFFFFF5C0),
        glowColor: Color(0xBBFFD700),
        glowRadius: 30,
        ringColors: [Color(0xFFFFF0A0), Color(0xFFFFD700), Color(0xFFFFB020), Color(0xFFFFF0A0)],
        hasDoubleRing: true,
      );
    }
    if (day <= 150) {
      return const _OrbTier(
        colors: [Color(0xFFF0F0FF), Color(0xFFD0D8FF), Color(0xFFA0B0E0)],
        innerHighlight: Color(0xFFFFFFFF),
        glowColor: Color(0xBBD0D8FF),
        glowRadius: 32,
        ringColors: [Color(0xFFFFFFFF), Color(0xFFE0E8FF), Color(0xFFB0C0F0), Color(0xFFFFFFFF)],
        hasDoubleRing: true,
      );
    }
    if (day <= 180) {
      return const _OrbTier(
        colors: [Color(0xFFFFFFFF), Color(0xFFE0EEFF), Color(0xFFB0D0FF)],
        innerHighlight: Color(0xFFFFFFFF),
        glowColor: Color(0xCCE0EEFF),
        glowRadius: 34,
        ringColors: [Color(0xFFFFFFFF), Color(0xFFD0E8FF), Color(0xFF90B8FF), Color(0xFFFFFFFF)],
        hasDoubleRing: true,
      );
    }
    if (day <= 365) {
      return const _OrbTier(
        colors: [Color(0xFFFFFFFF), Color(0xFFFFF0D0), Color(0xFFFFD0E0)],
        innerHighlight: Color(0xFFFFFFFF),
        glowColor: Color(0xCCFFE8C0),
        glowRadius: 36,
        ringColors: [
          Color(0xFFFF80A0), Color(0xFFFFB060), Color(0xFFFFF080),
          Color(0xFF80FF90), Color(0xFF60C0FF), Color(0xFFB080FF),
          Color(0xFFFF80A0),
        ],
        hasDoubleRing: true,
      );
    }
    final extraGlow = math.min((day - 365) * 0.015, 8.0);
    return _OrbTier(
      colors: const [Color(0xFFFFFFFF), Color(0xFFF8F0FF), Color(0xFFE8D8FF)],
      innerHighlight: const Color(0xFFFFFFFF),
      glowColor: const Color(0xDDFFFFFF),
      glowRadius: 38 + extraGlow,
      ringColors: const [
        Color(0xFFFFFFFF), Color(0xFFFFD0E8), Color(0xFFD0E0FF),
        Color(0xFFD0FFE0), Color(0xFFFFF0C0), Color(0xFFFFD0E8),
        Color(0xFFFFFFFF),
      ],
      hasDoubleRing: true,
    );
  }
}

/// Paints a gradient ring (or double ring) around the orb.
class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.colors,
    required this.strokeWidth,
    this.hasDoubleRing = false,
  });

  final List<Color> colors;
  final double strokeWidth;
  final bool hasDoubleRing;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - strokeWidth / 2;

    final gradient = SweepGradient(colors: colors);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, paint);

    if (hasDoubleRing) {
      final outerRadius = radius + strokeWidth + 2;
      final outerRect = Rect.fromCircle(center: center, radius: outerRadius);
      final outerPaint = Paint()
        ..shader = gradient.createShader(outerRect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(center, outerRadius, outerPaint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.colors != colors ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.hasDoubleRing != hasDoubleRing;
}
