import 'package:flutter/material.dart';

/// Design system typography tokens.
/// All text styles are defined here for consistent typography.
abstract final class AppTypography {
  // ============================================
  // FONT FAMILY
  // ============================================

  /// Primary font family - used for body and UI text
  static const String fontFamily = 'Rubik';

  /// Display font family - for headlines (same as primary for consistency)
  static const String displayFontFamily = 'Rubik';

  // ============================================
  // FONT WEIGHTS
  // ============================================

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ============================================
  // FONT SIZES
  // ============================================

  static const double sizeXs = 10.0;
  static const double sizeSm = 12.0;
  static const double sizeMd = 14.0;
  static const double sizeLg = 16.0;
  static const double sizeXl = 18.0;
  static const double sizeXxl = 20.0;
  static const double sizeXxxl = 24.0;
  static const double sizeDisplay = 28.0;
  static const double sizeDisplayLg = 32.0;
  static const double sizeDisplayXl = 40.0;

  // ============================================
  // LINE HEIGHTS
  // ============================================

  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;

  // ============================================
  // LETTER SPACING
  // ============================================

  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;
  static const double letterSpacingWider = 1.0;

  // ============================================
  // DISPLAY STYLES
  // ============================================

  /// Display Large - largest display text
  static TextStyle get displayLarge => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: sizeDisplayXl,
        fontWeight: bold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTight,
      );

  /// Display Medium
  static TextStyle get displayMedium => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: sizeDisplayLg,
        fontWeight: bold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTight,
        decoration: TextDecoration.none,
      );

  // ============================================
  // HEADLINE STYLES
  // ============================================

  /// Headline XL - largest display text
  static TextStyle get headlineXl => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: sizeDisplayXl,
        fontWeight: bold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTight,
      );

  /// Headline Large
  static TextStyle get headlineLarge => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: sizeDisplayLg,
        fontWeight: bold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTight,
      );

  /// Headline Medium
  static TextStyle get headlineMedium => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: sizeDisplay,
        fontWeight: semiBold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTight,
      );

  /// Headline Small
  static TextStyle get headlineSmall => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: sizeXxxl,
        fontWeight: semiBold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTight,
      );

  // ============================================
  // TITLE STYLES
  // ============================================

  /// Title Large
  static TextStyle get titleLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeXxxl,
        fontWeight: semiBold,
        height: lineHeightNormal,
      );

  /// Title Medium
  static TextStyle get titleMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeXxl,
        fontWeight: semiBold,
        height: lineHeightNormal,
      );

  /// Title Small
  static TextStyle get titleSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeXl,
        fontWeight: medium,
        height: lineHeightNormal,
      );

  // ============================================
  // BODY STYLES
  // ============================================

  /// Body Large
  static TextStyle get bodyLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeLg,
        fontWeight: regular,
        height: lineHeightRelaxed,
        decoration: TextDecoration.none,
      );

  /// Body Medium
  static TextStyle get bodyMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeMd,
        fontWeight: regular,
        height: lineHeightRelaxed,
        decoration: TextDecoration.none,
      );

  /// Body Small
  static TextStyle get bodySmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeSm,
        fontWeight: regular,
        height: lineHeightRelaxed,
      );

  // ============================================
  // LABEL STYLES
  // ============================================

  /// Label Large - buttons, tabs
  static TextStyle get labelLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeMd,
        fontWeight: medium,
        height: lineHeightNormal,
        letterSpacing: letterSpacingWide,
      );

  /// Label Medium
  static TextStyle get labelMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeSm,
        fontWeight: medium,
        height: lineHeightNormal,
        letterSpacing: letterSpacingWide,
      );

  /// Label Small
  static TextStyle get labelSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeXs,
        fontWeight: medium,
        height: lineHeightNormal,
        letterSpacing: letterSpacingWider,
      );

  // ============================================
  // CAPTION / HELPER STYLES
  // ============================================

  /// Caption - small helper text
  static TextStyle get caption => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeSm,
        fontWeight: regular,
        height: lineHeightNormal,
      );

  /// Overline - all caps small text
  static TextStyle get overline => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeXs,
        fontWeight: medium,
        height: lineHeightNormal,
        letterSpacing: letterSpacingWider,
      );

  // ============================================
  // SPECIAL STYLES
  // ============================================

  /// Stats value - large numbers
  static TextStyle get statsValue => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: sizeDisplay,
        fontWeight: bold,
        height: lineHeightTight,
      );

  /// Stats label - small description
  static TextStyle get statsLabel => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeSm,
        fontWeight: regular,
        height: lineHeightNormal,
      );

  /// Button text
  static TextStyle get button => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeMd,
        fontWeight: semiBold,
        height: lineHeightNormal,
        letterSpacing: letterSpacingWide,
      );

  /// Navigation item
  static TextStyle get navItem => TextStyle(
        fontFamily: fontFamily,
        fontSize: sizeSm,
        fontWeight: medium,
        height: lineHeightNormal,
      );
}

