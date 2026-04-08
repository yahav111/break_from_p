import 'package:flutter/material.dart';

enum OnboardingBackgroundVariant { space, red, blue, teal }

/// Shared gradient background used across all onboarding screens.
class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({
    super.key,
    this.variant = OnboardingBackgroundVariant.space,
  });

  final OnboardingBackgroundVariant variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: _gradient),
    );
  }

  LinearGradient get _gradient {
    switch (variant) {
      case OnboardingBackgroundVariant.space:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0D2E), Color(0xFF1A1050), Color(0xFF0A0D2E)],
          stops: [0, 0.5, 1],
        );
      case OnboardingBackgroundVariant.red:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB71C1C), Color(0xFFC62828), Color(0xFFD32F2F)],
          stops: [0, 0.5, 1],
        );
      case OnboardingBackgroundVariant.blue:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1976D2)],
          stops: [0, 0.5, 1],
        );
      case OnboardingBackgroundVariant.teal:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A1628), Color(0xFF0D2137), Color(0xFF0A1628)],
          stops: [0, 0.5, 1],
        );
    }
  }

  /// Interpolates between two background variants based on [t] (0.0 to 1.0).
  static Widget interpolated({
    required OnboardingBackgroundVariant from,
    required OnboardingBackgroundVariant to,
    required double t,
  }) {
    final fromBg = OnboardingBackground(variant: from);
    final toBg = OnboardingBackground(variant: to);

    final fromColors = fromBg._gradient.colors;
    final toColors = toBg._gradient.colors;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(fromColors[0], toColors[0], t)!,
            Color.lerp(fromColors[1], toColors[1], t)!,
            Color.lerp(fromColors[2], toColors[2], t)!,
          ],
          stops: const [0, 0.5, 1],
        ),
      ),
    );
  }
}
