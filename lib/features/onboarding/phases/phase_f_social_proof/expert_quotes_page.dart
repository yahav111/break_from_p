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
    'ד״ר',
    'שפר את חייך באופן דרמטי',
    'איפוס מאזן הדופמין על ידי הפסקה מתוכן ממריץ ביותר יכול לשפר באופן דרמטי את המוטיבציה, היציבות הרגשית וההנאה היומיומית.',
  ),
  _Quote(
    'Steven Bartlett',
    'יזם',
    'אין שום דבר טוב בפורנו',
    'לפורנוגרפיה אין תפקיד חינוכי — היא רק חלון פתוח לשוק שמביא יותר ריקנות והתמכרות מאשר תועלת.',
  ),
  _Quote(
    'קונור',
    'משתמש QUITTR',
    'הגמילה אפשרה לי לשנות את התפיסה על הדברים הקטנים בחיים.',
    'הייתי בשלב שבו כבר השלמתי עם העובדה שהחיים אפלים, משעממים, מדכאים, ובסוף מתים. די לזה. הגמילה אפשרה לי לשנות את התפיסה שלי על הדברים הקטנים בחיים.',
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
