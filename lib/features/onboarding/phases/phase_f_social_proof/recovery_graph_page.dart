import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';
import '../phase_h_paywall/models/recovery_plan.dart';
import '../phase_h_paywall/recovery_plan_provider.dart';

/// Recovery graph showing 3 paths: relapses, conventional, QUITTR.
/// Curves are generated from the user's computed [RecoveryPlan] so the week
/// count and trajectory reflect their own quiz answers.
class RecoveryGraphPage extends ConsumerWidget {
  const RecoveryGraphPage({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(recoveryPlanProvider);

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
                      'החלמה מפורנו',
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
                          ' - הישנות',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  'QUITTER PRO',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTypography.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Custom painted graph, driven by the user's plan.
            SizedBox(
              height: 200,
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: _RecoveryGraphPainter(weeks: plan.weeks),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegend(AppColors.success, 'QUITTER PRO'),
                _buildLegend(Colors.white, 'רגיל'),
                _buildLegend(AppColors.error, 'הישנות'),
              ],
            ),
            const Spacer(flex: 1),
            Text(
              'יתרונות החיווט מחדש',
              style: AppTypography.headlineSmall.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.semiBold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'על פי התשובות שלך, QUITTR צופה החלמה של כ-'
              '${plan.totalDays} ימים — עם הרבה פחות הישנויות מאשר לבד.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
                height: 1.5,
              ),
            ),
            const Spacer(flex: 1),
            AppButton(
              label: 'המשך',
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
  const _RecoveryGraphPainter({required this.weeks});

  final List<RecoveryWeekPoint> weeks;

  @override
  void paint(Canvas canvas, Size size) {
    final n = weeks.length;
    if (n == 0) return;

    final w = size.width;
    final h = size.height;
    const margin = 12.0;

    double xFromIndex(int i) => n == 1 ? w / 2 : (i / (n - 1)) * w;
    // progress 0..1 → higher progress drawn near top of canvas
    double yFromProgress(double p) =>
        h - margin - p * (h - 2 * margin);

    // Grid lines at each week boundary (skip the first).
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;
    for (int i = 1; i < n; i++) {
      final x = xFromIndex(i);
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }

    // Build the three point lists from the week data.
    final relapsePts = [
      for (var i = 0; i < n; i++)
        Offset(xFromIndex(i), yFromProgress(weeks[i].relapses)),
    ];
    final conventionalPts = [
      for (var i = 0; i < n; i++)
        Offset(xFromIndex(i), yFromProgress(weeks[i].conventional)),
    ];
    final quittrPts = [
      for (var i = 0; i < n; i++)
        Offset(xFromIndex(i), yFromProgress(weeks[i].quittr)),
    ];

    _drawSmooth(
      canvas,
      relapsePts,
      Paint()
        ..color = const Color(0xFFEF5350)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );
    _drawSmooth(
      canvas,
      conventionalPts,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.7)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );
    _drawSmooth(
      canvas,
      quittrPts,
      Paint()
        ..color = const Color(0xFF4CAF50)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    // Endpoint dot for QUITTR trajectory.
    canvas.drawCircle(
      quittrPts.last,
      5,
      Paint()..color = const Color(0xFF4CAF50),
    );

    // Week labels: show at most 5 tick labels.
    final labelIndices = _pickLabelIndices(n);
    final textStyle = TextStyle(
      color: Colors.white.withValues(alpha: 0.4),
      fontSize: 10,
    );
    for (final i in labelIndices) {
      final tp = TextPainter(
        text: TextSpan(text: 'שבוע ${i + 1}', style: textStyle),
        textDirection: TextDirection.rtl,
      )..layout();
      tp.paint(
        canvas,
        Offset(xFromIndex(i) - tp.width / 2, h - tp.height),
      );
    }
  }

  void _drawSmooth(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.isEmpty) return;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    if (points.length == 1) {
      canvas.drawPath(path, paint);
      return;
    }
    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final midX = (p0.dx + p1.dx) / 2;
      path.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
    }
    canvas.drawPath(path, paint);
  }

  Set<int> _pickLabelIndices(int n) {
    if (n <= 5) return {for (int i = 0; i < n; i++) i};
    return <int>{
      0,
      (n / 4).round(),
      (n / 2).round(),
      (3 * n / 4).round(),
      n - 1,
    };
  }

  @override
  bool shouldRepaint(covariant _RecoveryGraphPainter oldDelegate) {
    return oldDelegate.weeks != weeks;
  }
}
