import 'package:flutter/material.dart';

class FeatureSlideData {
  const FeatureSlideData({
    required this.title,
    required this.body,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String body;
  final IconData icon;
  final Color iconColor;
}

const featureSlides = <FeatureSlideData>[
  FeatureSlideData(
    title: 'Welcome to QUITTR',
    body:
        'With over 1,000,000 users, QUITTR is **class-leading** and based on **years of research** and user-interaction.',
    icon: Icons.rocket_launch_rounded,
    iconColor: Color(0xFF64B5F6),
  ),
  FeatureSlideData(
    title: 'Rewire your brain',
    body:
        'Science-backed exercises help you **rewire** your brain, **rebuild** your dopamine receptors, and **avoid setbacks**.',
    icon: Icons.psychology_alt_rounded,
    iconColor: Color(0xFFFFD54F),
  ),
  FeatureSlideData(
    title: 'Conquer yourself',
    body:
        '**Know yourself** to conquer yourself. Understand your **strengths** and **weaknesses**, earn medals, and track your **progress**.',
    icon: Icons.military_tech_rounded,
    iconColor: Color(0xFF81C784),
  ),
  FeatureSlideData(
    title: 'Avoid setbacks',
    body:
        'QUITTR **learns your habits** and temptation triggers, providing you with **24/7 protection**.',
    icon: Icons.shield_rounded,
    iconColor: Color(0xFFFF8A65),
  ),
  FeatureSlideData(
    title: 'Level up your life',
    body:
        'Rebooting has immense **psychological** and **physical** benefits. Grow stronger, healthier, and happier.',
    icon: Icons.trending_up_rounded,
    iconColor: Color(0xFF4FC3F7),
  ),
];
