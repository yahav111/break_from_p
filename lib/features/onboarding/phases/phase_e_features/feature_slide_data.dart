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
    title: 'ברוכים הבאים ל-QUITTR',
    body:
        'עם מעל 1,000,000 משתמשים, QUITTR הוא **מוביל בתחומו** ומבוסס על **שנים של מחקר** ואינטראקציה עם משתמשים.',
    icon: Icons.rocket_launch_rounded,
    iconColor: Color(0xFF64B5F6),
  ),
  FeatureSlideData(
    title: 'אתחל את המוח שלך',
    body:
        'תרגילים מבוססי מדע עוזרים לך **לחווט מחדש** את המוח, **לשחזר** את קולטני הדופמין, ו**למנוע הישנות**.',
    icon: Icons.psychology_alt_rounded,
    iconColor: Color(0xFFFFD54F),
  ),
  FeatureSlideData(
    title: 'כבוש את עצמך',
    body:
        '**הכר את עצמך** כדי לכבוש את עצמך. הבן את **נקודות החוזק** וה**חולשה** שלך, אסוף הישגים ועקוב אחר **התקדמותך**.',
    icon: Icons.military_tech_rounded,
    iconColor: Color(0xFF81C784),
  ),
  FeatureSlideData(
    title: 'מנע הישנות',
    body:
        'QUITTR **לומד את ההרגלים שלך** ואת הטריגרים, ומספק לך **הגנה 24/7**.',
    icon: Icons.shield_rounded,
    iconColor: Color(0xFFFF8A65),
  ),
  FeatureSlideData(
    title: 'שדרג את החיים שלך',
    body:
        'התאפסות מביאה ליתרונות **נפשיים** ו**פיזיים** עצומים. תהיה חזק, בריא ומאושר יותר.',
    icon: Icons.trending_up_rounded,
    iconColor: Color(0xFF4FC3F7),
  ),
];
