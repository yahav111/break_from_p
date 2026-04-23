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
    title: 'פורנו הוא סם',
    body:
        'צפייה בפורנו משחררת במוח חומר בשם **דופמין**. חומר זה גורם לך **להרגיש טוב** — לכן אתה חש הנאה כשאתה צופה.',
    icon: Icons.psychology_rounded,
    iconColor: Color(0xFFFF8A80),
  ),
  EducationSlideData(
    title: 'פורנו הורס מערכות יחסים',
    body:
        'פורנו **מפחית** את הרצון שלך ל**מערכת יחסים אמיתית** ומחליף אותו בצמא לעוד פורנו.',
    icon: Icons.heart_broken_rounded,
    iconColor: Color(0xFFFF8A80),
  ),
  EducationSlideData(
    title: 'פורנו מרסק את החשק המיני',
    body:
        'יותר מ-**50%** ממכורי הפורנו דיווחו על **אובדן עניין** במין אמיתי וירידה כללית בחשק המיני.',
    icon: Icons.block_rounded,
    iconColor: Color(0xFFFF8A80),
  ),
  EducationSlideData(
    title: 'מרגיש לא מרוצה?',
    body:
        '**רמת דופמין גבוהה** אומרת שאתה זקוק ליותר דופמין כדי להרגיש טוב. לכן משתמשים כבדים רבים מרגישים **דיכאון**, **חוסר מוטיבציה** ו**בידוד חברתי**.',
    icon: Icons.sentiment_dissatisfied_rounded,
    iconColor: Color(0xFF90CAF9),
  ),
  EducationSlideData(
    title: 'הדרך להחלמה',
    body:
        'החלמה אפשרית. באמצעות **התנזרות מפורנו**, המוח שלך יכול **לאפס את רגישות הדופמין** ולהוביל למערכות יחסים בריאות יותר ולתחושת **רווחה משופרת**.',
    icon: Icons.eco_rounded,
    iconColor: Color(0xFF81C784),
    background: OnboardingBackgroundVariant.blue,
  ),
];
