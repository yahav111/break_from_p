import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';

/// Recovery graph showing 3 paths: relapses, conventional, QUITTR.
class RecoveryGraphPage extends StatelessWidget {
  const RecoveryGraphPage({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Graph header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Porn Recovery',
                      style: AppTypography.headlineMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTypography.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Text(
                          'X',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.error,
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                        Text(
                          ' - relapses',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  'QUITTR',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTypography.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Custom painted graph
            SizedBox(
              height: 200,
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: _RecoveryGraphPainter(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegend(AppColors.success, 'QUITTR'),
                _buildLegend(Colors.white, 'Conventional'),
                _buildLegend(AppColors.error, 'Relapses'),
              ],
            ),
            const Spacer(flex: 1),
            Text(
              'Rewiring Benefits',
              style: AppTypography.headlineSmall.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.semiBold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'QUITTR\'s structured approach helps you break free faster with fewer relapses than going it alone.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
                height: 1.5,
              ),
            ),
            const Spacer(flex: 1),
            AppButton(
              label: 'Next',
              isFullWidth: true,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.large,
              onPressed: onNext,
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _RecoveryGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;
    for (int i = 1; i <= 3; i++) {
      final x = w * i / 3;
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }

    // Relapses path (red, oscillating low)
    final relapsePaint = Paint()
      ..color = const Color(0xFFEF5350)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final relapsePath = Path()
      ..moveTo(0, h * 0.7)
      ..cubicTo(w * 0.15, h * 0.5, w * 0.2, h * 0.8, w * 0.33, h * 0.6)
      ..cubicTo(w * 0.45, h * 0.4, w * 0.5, h * 0.9, w * 0.66, h * 0.7)
      ..cubicTo(w * 0.8, h * 0.5, w * 0.85, h * 0.85, w, h * 0.75);
    canvas.drawPath(relapsePath, relapsePaint);

    // Conventional path (white, flat-ish)
    final conventionalPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final conventionalPath = Path()
      ..moveTo(0, h * 0.7)
      ..cubicTo(w * 0.2, h * 0.6, w * 0.4, h * 0.55, w * 0.6, h * 0.5)
      ..cubicTo(w * 0.75, h * 0.45, w * 0.9, h * 0.42, w, h * 0.4);
    canvas.drawPath(conventionalPath, conventionalPaint);

    // QUITTR path (green, ascending strongly)
    final quittrPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final quittrPath = Path()
      ..moveTo(0, h * 0.7)
      ..cubicTo(w * 0.2, h * 0.5, w * 0.4, h * 0.35, w * 0.6, h * 0.25)
      ..cubicTo(w * 0.75, h * 0.18, w * 0.9, h * 0.12, w, h * 0.08);
    canvas.drawPath(quittrPath, quittrPaint);

    // Endpoint dot for QUITTR
    canvas.drawCircle(
      Offset(w, h * 0.08),
      5,
      Paint()..color = const Color(0xFF4CAF50),
    );

    // Week labels
    final textStyle = TextStyle(
      color: Colors.white.withValues(alpha: 0.4),
      fontSize: 10,
    );
    for (int i = 1; i <= 3; i++) {
      final tp = TextPainter(
        text: TextSpan(text: 'Week $i', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(w * i / 3 - tp.width / 2, h - tp.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
