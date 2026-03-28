import 'package:flutter/material.dart';

/// Design system shadow/elevation tokens.
/// Consistent shadows for depth and elevation throughout the app.
abstract final class AppShadows {
  // ============================================
  // DARK THEME SHADOWS
  // ============================================

  /// No shadow
  static const List<BoxShadow> none = [];

  /// Small shadow – subtle elevation (dark theme)
  static const List<BoxShadow> smDark = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Medium shadow – card elevation (dark theme)
  static const List<BoxShadow> mdDark = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 8,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Large shadow – modal elevation (dark theme)
  static const List<BoxShadow> lgDark = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 16,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Extra large shadow – floating elements (dark theme)
  static const List<BoxShadow> xlDark = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 24,
      offset: Offset(0, 12),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 12,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  // ============================================
  // LIGHT THEME SHADOWS
  // ============================================

  /// Small shadow – subtle elevation (light theme)
  static const List<BoxShadow> smLight = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Medium shadow – card elevation (light theme)
  static const List<BoxShadow> mdLight = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Large shadow – modal elevation (light theme)
  static const List<BoxShadow> lgLight = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 16,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 8,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Extra large shadow – floating elements (light theme)
  static const List<BoxShadow> xlLight = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 24,
      offset: Offset(0, 12),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  // ============================================
  // COLORED GLOWS (for accent elements)
  // ============================================

  /// Primary purple glow – for CTA buttons and highlighted elements
  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: Color(0x667B61FF), // primary purple @ 40%
      blurRadius: 20,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x337B61FF), // primary purple @ 20%
      blurRadius: 40,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Gradient CTA glow – purple-to-pink shimmer for gradient buttons
  static const List<BoxShadow> gradientGlow = [
    BoxShadow(
      color: Color(0x66BE3FD8), // gradientEnd @ 40%
      blurRadius: 20,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x337B61FF), // gradientStart @ 20%
      blurRadius: 40,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Success color glow
  static const List<BoxShadow> successGlow = [
    BoxShadow(
      color: Color(0x404ECB71),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Error color glow
  static const List<BoxShadow> errorGlow = [
    BoxShadow(
      color: Color(0x40FF5252),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  // ============================================
  // INNER SHADOWS (for pressed states)
  // ============================================

  /// Inner shadow for pressed state
  static const List<BoxShadow> innerSm = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  // ============================================
  // ELEVATION HELPERS
  // ============================================

  /// Get shadows based on elevation level (0–4) and brightness
  static List<BoxShadow> getElevation(int level, Brightness brightness) {
    final shadows = brightness == Brightness.dark
        ? [none, smDark, mdDark, lgDark, xlDark]
        : [none, smLight, mdLight, lgLight, xlLight];

    return shadows[level.clamp(0, 4)];
  }
}
