import 'package:flutter/material.dart';

import '../../../shared/widgets/star_field.dart';
import 'onboarding_background.dart';

/// Common layout template for onboarding screens:
/// Background gradient + StarField + SafeArea + content.
class OnboardingPageTemplate extends StatelessWidget {
  const OnboardingPageTemplate({
    super.key,
    required this.child,
    this.variant = OnboardingBackgroundVariant.space,
    this.starDensity = 60,
    this.showStars = true,
    this.customBackground,
  });

  final Widget child;
  final OnboardingBackgroundVariant variant;
  final int starDensity;
  final bool showStars;

  /// Optional custom background widget (overrides variant).
  final Widget? customBackground;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        customBackground ?? OnboardingBackground(variant: variant),
        if (showStars) StarField(density: starDensity),
        SafeArea(child: child),
      ],
    );
  }
}
