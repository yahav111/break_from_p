import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_background.dart';
import '../../widgets/onboarding_page_template.dart';
import '../../widgets/page_dots_indicator.dart';
import 'feature_slide_data.dart';
import 'widgets/press_logo_row.dart';

/// Feature showcase carousel: 5 slides about QUITTR features.
class FeatureShowcasePage extends StatefulWidget {
  const FeatureShowcasePage({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<FeatureShowcasePage> createState() => _FeatureShowcasePageState();
}

class _FeatureShowcasePageState extends State<FeatureShowcasePage> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final page = _controller.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      variant: OnboardingBackgroundVariant.teal,
      child: Column(
        children: [
          // QUITTR logo at top
          const SizedBox(height: AppSpacing.lg),
          Text(
            'QUITTR',
            style: AppTypography.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.bold,
              letterSpacing: 4,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: featureSlides.length,
              itemBuilder: (context, index) {
                return _buildSlide(featureSlides[index]);
              },
            ),
          ),
          const PressLogoRow(),
          const SizedBox(height: AppSpacing.xxl),
          PageDotsIndicator(
            count: featureSlides.length,
            currentIndex: _currentPage,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: AppButton(
              label: 'Next',
              isFullWidth: true,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.large,
              icon: Icons.arrow_forward_rounded,
              iconPosition: AppButtonIconPosition.trailing,
              onPressed: () {
                if (_currentPage >= featureSlides.length - 1) {
                  widget.onComplete();
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildSlide(FeatureSlideData slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(slide.icon, size: 80, color: slide.iconColor),
          const SizedBox(height: AppSpacing.xxxl),
          Text(
            slide.title,
            style: AppTypography.displayMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          _buildRichBody(slide.body),
        ],
      ),
    );
  }

  Widget _buildRichBody(String text) {
    final spans = <TextSpan>[];
    final parts = text.split('**');
    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(
        text: parts[i],
        style: i.isOdd
            ? const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
            : null,
      ));
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTypography.bodyLarge.copyWith(
          color: Colors.white.withValues(alpha: 0.85),
          height: 1.6,
        ),
        children: spans,
      ),
    );
  }
}
