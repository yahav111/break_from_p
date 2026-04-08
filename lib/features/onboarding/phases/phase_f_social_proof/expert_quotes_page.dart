import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';

class _Quote {
  const _Quote(this.name, this.title, this.heading, this.body);
  final String name;
  final String title;
  final String heading;
  final String body;
}

const _quotes = <_Quote>[
  _Quote(
    'Andrew Huberman',
    'Ph.D.',
    'Drastically improve your life',
    'Resetting your dopamine balance by taking a break from highly stimulating content can dramatically improve motivation, emotional stability, and everyday pleasure.',
  ),
  _Quote(
    'Steven Bartlett',
    'Entrepreneur',
    'There\'s no good in porn',
    'Pornography doesn\'t have an educational role — it\'s only an open window for a market that brings more emptiness and addiction that profit to porn.',
  ),
  _Quote(
    'Connor',
    'QUITTR User',
    'Quitting has allowed me to change my mindset on the little things in life.',
    'I was coming to grips with the fact that life is dark, boring, depressing and then I die. Screw that. Quitting has allowed me to change my mindset on the little things in life.',
  ),
];

/// Expert quotes and user testimonials in chat-bubble style.
class ExpertQuotesPage extends StatelessWidget {
  const ExpertQuotesPage({super.key, required this.onNext});

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
              itemCount: _quotes.length,
              itemBuilder: (context, index) {
                return _buildQuoteCard(_quotes[index]);
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

  Widget _buildQuoteCard(_Quote quote) {
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
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  quote.name[0],
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quote.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: Colors.white,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                    Text(
                      quote.title,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.darkTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            quote.heading,
            style: AppTypography.titleSmall.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            quote.body,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
