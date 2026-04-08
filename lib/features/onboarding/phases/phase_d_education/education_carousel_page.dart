import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_background.dart';
import '../../widgets/page_dots_indicator.dart';
import 'education_slide_data.dart';

/// Education carousel: 5 slides about the harm of porn,
/// with red→blue background transition on the last slide.
class EducationCarouselPage extends StatefulWidget {
  const EducationCarouselPage({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<EducationCarouselPage> createState() => _EducationCarouselPageState();
}

class _EducationCarouselPageState extends State<EducationCarouselPage> {
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
    return Stack(
      fit: StackFit.expand,
      children: [
        // Animated background: red for slides 0-3, transitions to blue on slide 4
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final page = _controller.hasClients
                ? (_controller.page ?? 0.0)
                : 0.0;
            // Transition starts at page 3→4
            final t = ((page - 3.0) / 1.0).clamp(0.0, 1.0);
            return OnboardingBackground.interpolated(
              from: OnboardingBackgroundVariant.red,
              to: OnboardingBackgroundVariant.blue,
              t: t,
            );
          },
        ),
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: educationSlides.length,
                  itemBuilder: (context, index) {
                    return _buildSlide(educationSlides[index]);
                  },
                ),
              ),
              PageDotsIndicator(
                count: educationSlides.length,
                currentIndex: _currentPage,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl),
                child: AppButton(
                  label: 'Next',
                  isFullWidth: true,
                  variant: AppButtonVariant.primary,
                  size: AppButtonSize.large,
                  icon: Icons.arrow_forward_rounded,
                  iconPosition: AppButtonIconPosition.trailing,
                  onPressed: () {
                    if (_currentPage >= educationSlides.length - 1) {
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
        ),
      ],
    );
  }

  Widget _buildSlide(EducationSlideData slide) {
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

  /// Renders body text with **bold** markdown-style formatting.
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
