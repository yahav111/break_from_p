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
    'Tony Coleman',
    '@tcoleman23',
    'I was skeptical at first, but QUITTR\'s panic button feature has helped me resist temptation multiple times. The app\'s educational content has also opened my eyes to the negative effects of porn. Highly recommend!',
    5,
  ),
  _Testimonial(
    'David Lee',
    '@davidleeeee',
    'Thanks to QUITTR, I\'ve been able to quit porn and focus on healthier habits. The app\'s adult content blocker is incredibly effective, and the benefits of quitting have been amazing.',
    5,
  ),
  _Testimonial(
    'Michael R.',
    '@michaelr_fit',
    'The progress tracking and motivational notifications have kept me on track. I haven\'t watched porn in 3 months and feel more in control of my life.',
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
              label: 'Next',
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
