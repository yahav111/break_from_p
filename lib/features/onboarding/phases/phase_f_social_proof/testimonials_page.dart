import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';

class _Testimonial {
  const _Testimonial(this.name, this.handle, this.text, this.stars);
  final String name;
  final String handle;
  final String text;
  final int stars;
}

const _testimonials = <_Testimonial>[
  _Testimonial(
    'טוני קולמן',
    '@tcoleman23',
    'בהתחלה הייתי סקפטי, אבל כפתור הפניקה של QUITTR עזר לי להתגבר על פיתויים הרבה פעמים. גם התוכן החינוכי פקח לי את העיניים לגבי ההשפעה השלילית של פורנו. ממליץ בחום!',
    5,
  ),
  _Testimonial(
    'דיוויד לי',
    '@davidleeeee',
    'הודות ל-QUITTR הצלחתי לגמול מעצמי ולהתמקד בהרגלים בריאים יותר. החוסם של תוכן למבוגרים יעיל מאוד, והיתרונות של הגמילה מדהימים.',
    5,
  ),
  _Testimonial(
    'מייקל ר.',
    '@michaelr_fit',
    'מעקב ההתקדמות וההתראות המעודדות שמרו אותי על המסלול. כבר 3 חודשים שלא צפיתי בפורנו ואני מרגיש הרבה יותר שולט בחיים שלי.',
    5,
  ),
];

/// Testimonials page with star-rated review cards.
class TestimonialsPage extends StatelessWidget {
  const TestimonialsPage({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl),
              itemCount: _testimonials.length,
              itemBuilder: (context, index) {
                return _buildCard(_testimonials[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: AppButton(
              label: 'המשך',
              isFullWidth: true,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.large,
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(_Testimonial t) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
                child: Text(
                  t.name[0],
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: Colors.white,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                    Text(
                      t.handle,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.darkTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  t.stars,
                  (_) => const Icon(Icons.star_rounded,
                      color: Color(0xFFFFD700), size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '"${t.text}"',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
