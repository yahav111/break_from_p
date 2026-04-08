import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';

/// Symptom category and item data.
class _SymptomCategory {
  const _SymptomCategory(this.title, this.symptoms);
  final String title;
  final List<String> symptoms;
}

const _categories = <_SymptomCategory>[
  _SymptomCategory('Mental', [
    'Difficulty concentrating',
    'Lack of ambition to pursue goals',
    'Poor memory or \'brain fog\'',
    'General anxiety',
    'Feeling unmotivated',
  ]),
  _SymptomCategory('Physical', [
    'Tiredness and lethargy',
    'Weak erections without porn',
    'Low sex drive or desire',
  ]),
  _SymptomCategory('Social', [
    'Unsuccessful or unenjoyable sex',
    'Low self-confidence',
    'Feeling unattractive or unworthy of love',
    'Feeling isolated from others',
    'Reduced desire to socialize',
  ]),
  _SymptomCategory('Faith', [
    'Feeling distant from God',
  ]),
];

/// Symptoms selection page with grouped checkboxes.
class SymptomsSelectionPage extends StatefulWidget {
  const SymptomsSelectionPage({
    super.key,
    required this.onComplete,
    required this.onSymptomsChanged,
  });

  final VoidCallback onComplete;
  final ValueChanged<List<String>> onSymptomsChanged;

  @override
  State<SymptomsSelectionPage> createState() => _SymptomsSelectionPageState();
}

class _SymptomsSelectionPageState extends State<SymptomsSelectionPage> {
  final _selected = <String>{};

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          _buildHeader(),
          const SizedBox(height: AppSpacing.md),
          _buildInfoBanner(),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              children: [
                for (final category in _categories) ...[
                  _buildCategoryHeader(category.title),
                  const SizedBox(height: AppSpacing.sm),
                  for (final symptom in category.symptoms)
                    _buildSymptomTile(symptom),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: GradientButton(
              label: 'Reboot my brain',
              isFullWidth: true,
              size: AppButtonSize.large,
              gradientColors: const [Color(0xFFFF5722), Color(0xFFFF9800)],
              onPressed: () {
                widget.onSymptomsChanged(_selected.toList());
                widget.onComplete();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.overlayWhiteSubtle,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Text(
            'Symptoms',
            style: AppTypography.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border:
              Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Text(
          'Excessive porn use can have negative impacts psychologically.\n\nSelect any symptoms below:',
          style: AppTypography.bodyMedium.copyWith(
            color: Colors.white,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Text(
        title,
        style: AppTypography.titleMedium.copyWith(
          color: AppColors.darkTextSecondary,
          fontWeight: AppTypography.semiBold,
        ),
      ),
    );
  }

  Widget _buildSymptomTile(String symptom) {
    final isSelected = _selected.contains(symptom);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selected.remove(symptom);
          } else {
            _selected.add(symptom);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.error.withValues(alpha: 0.15)
              : AppColors.darkCard,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: isSelected
                ? AppColors.error.withValues(alpha: 0.5)
                : AppColors.darkBorderSubtle,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.error
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.error
                      : AppColors.darkBorderSubtle,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                symptom,
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight:
                      isSelected ? AppTypography.semiBold : AppTypography.regular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
