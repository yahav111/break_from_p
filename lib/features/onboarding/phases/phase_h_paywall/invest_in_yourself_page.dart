import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';

/// "Now, it's time to invest in yourself" with streak card preview.
class InvestInYourselfPage extends StatelessWidget {
  const InvestInYourselfPage({
    super.key,
    required this.onNext,
    this.userName,
  });

  final VoidCallback onNext;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final name = (userName?.isNotEmpty == true) ? userName! : 'חבר';
    final now = DateTime.now();
    final dateStr =
        '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';

    return OnboardingPageTemplate(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          children: [
            const Spacer(flex: 2),
            Text(
              'עכשיו הזמן\nלהשקיע בעצמך.',
              textAlign: TextAlign.center,
              style: AppTypography.displayLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
                fontSize: 30,
                height: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            // Mini streak card
            Container(
              width: 200,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.large),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF667EEA),
                    Color(0xFFFF6B6B),
                    Color(0xFFFF9A56),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('QTR',
                            style: AppTypography.caption
                                .copyWith(color: Colors.white)),
                      ),
                      Icon(Icons.share_rounded,
                          color: Colors.white.withValues(alpha: 0.6),
                          size: 16),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('רצף פעיל',
                      style: AppTypography.caption
                          .copyWith(color: Colors.white70)),
                  Text('0 ימים',
                      style: AppTypography.headlineSmall
                          .copyWith(color: Colors.white, fontWeight: AppTypography.bold)),
                  const Divider(color: Colors.white24, height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('שם',
                              style: AppTypography.caption
                                  .copyWith(color: Colors.white54, fontSize: 9)),
                          Text(name,
                              style: AppTypography.bodySmall
                                  .copyWith(color: Colors.white)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('נקי מאז',
                              style: AppTypography.caption
                                  .copyWith(color: Colors.white54, fontSize: 9)),
                          Text(dateStr,
                              style: AppTypography.bodySmall
                                  .copyWith(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
            GestureDetector(
              onTap: onNext,
              child: Text(
                'הקש כדי להמשיך',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
