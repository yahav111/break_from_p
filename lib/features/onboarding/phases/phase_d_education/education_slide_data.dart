import 'package:flutter/material.dart';

import '../../widgets/onboarding_background.dart';

class EducationSlideData {
  const EducationSlideData({
    required this.title,
    required this.body,
    required this.icon,
    required this.iconColor,
    this.background = OnboardingBackgroundVariant.red,
  });

  final String title;
  final String body;
  final IconData icon;
  final Color iconColor;
  final OnboardingBackgroundVariant background;
}

const educationSlides = <EducationSlideData>[
  EducationSlideData(
    title: 'Porn is a drug',
    body:
        'Using porn releases a chemical in the brain called **dopamine**. This chemical makes you **feel good** — it\'s why you feel pleasure when you watch porn.',
    icon: Icons.psychology_rounded,
    iconColor: Color(0xFFFF8A80),
  ),
  EducationSlideData(
    title: 'Porn destroys relationships',
    body:
        'Porn **reduces** your hunger for a **real relationship** and replaces it with the hunger for more porn.',
    icon: Icons.heart_broken_rounded,
    iconColor: Color(0xFFFF8A80),
  ),
  EducationSlideData(
    title: 'Porn shatters sex drive',
    body:
        'More than **50%** of porn addicts have reported a **loss of interest** in real sex, and an overall **decrease** in their sex drive.',
    icon: Icons.block_rounded,
    iconColor: Color(0xFFFF8A80),
  ),
  EducationSlideData(
    title: 'Feeling unhappy?',
    body:
        'An **elevated dopamine level** means you need more dopamine to feel good. This is why so many heavy porn users report feeling **depressed**, **unmotivated**, and **anti-social**.',
    icon: Icons.sentiment_dissatisfied_rounded,
    iconColor: Color(0xFF90CAF9),
  ),
  EducationSlideData(
    title: 'Path to Recovery',
    body:
        'Recovery is possible. By **abstaining from porn**, your brain can **reset its dopamine sensitivity**, leading to healthier relationships and **improved well-being**.',
    icon: Icons.eco_rounded,
    iconColor: Color(0xFF81C784),
    background: OnboardingBackgroundVariant.blue,
  ),
];
