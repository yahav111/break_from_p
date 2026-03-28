import 'package:flutter/material.dart';

/// Design system color tokens – QUITTR Night-Sky / Space theme.
/// All colors are semantic and should be used through theme context.
abstract final class AppColors {
  // ============================================
  // DARK THEME COLORS (Night Sky / Deep Space)
  // ============================================

  /// Deep background – darkest layer (deep navy / space)
  static const Color darkBackground = Color(0xFF0A0D2E);

  /// Surface color – primary surface layer
  static const Color darkSurface = Color(0xFF111540);

  /// Card background – elevated cards
  static const Color darkCard = Color(0xFF1A1F52);

  /// Elevated surface – highest elevation
  static const Color darkElevated = Color(0xFF242966);

  /// Border color for dark theme
  static const Color darkBorder = Color(0xFF2A3070);

  /// Subtle border for dark theme
  static const Color darkBorderSubtle = Color(0xFF1E2260);

  /// Text colors for dark theme
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B8D4);
  static const Color darkTextTertiary = Color(0xFF606A9B);
  static const Color darkTextDisabled = Color(0xFF3A4070);

  // ============================================
  // LIGHT THEME COLORS
  // ============================================

  /// Clean background – lightest layer
  static const Color lightBackground = Color(0xFFF4F5FF);

  /// Surface color – primary surface layer
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Card background – elevated cards
  static const Color lightCard = Color(0xFFEEEFF8);

  /// Elevated surface – highest elevation
  static const Color lightElevated = Color(0xFFFFFFFF);

  /// Border color for light theme
  static const Color lightBorder = Color(0xFFD4D6F0);

  /// Subtle border for light theme
  static const Color lightBorderSubtle = Color(0xFFEEEFF8);

  /// Text colors for light theme
  static const Color lightTextPrimary = Color(0xFF0A0D2E);
  static const Color lightTextSecondary = Color(0xFF3D4280);
  static const Color lightTextTertiary = Color(0xFF7880BC);
  static const Color lightTextDisabled = Color(0xFFB0B8D4);

  // ============================================
  // ACCENT / BRAND COLORS (Purple)
  // ============================================

  /// Primary brand color – vibrant purple
  static const Color primary = Color(0xFF7B61FF);
  static const Color primaryLight = Color(0xFF9D86FF);
  static const Color primaryDark = Color(0xFF5B3EDD);

  /// Secondary color – vibrant green (success / streak)
  static const Color secondary = Color(0xFF4ECB71);
  static const Color secondaryLight = Color(0xFF7ADB94);
  static const Color secondaryDark = Color(0xFF36A855);

  /// Tertiary color – warm orange (warning / highlights)
  static const Color tertiary = Color(0xFFFF9F43);
  static const Color tertiaryLight = Color(0xFFFFB86C);
  static const Color tertiaryDark = Color(0xFFE88A2D);

  // ============================================
  // GRADIENT COLORS
  // ============================================

  /// Primary gradient – purple to pink-purple (CTA buttons, hero elements)
  static const Color gradientStart = Color(0xFF7B61FF);
  static const Color gradientEnd = Color(0xFFBE3FD8);

  /// Alternative gradient – deeper purple to violet
  static const Color gradientAltStart = Color(0xFF5B3EDD);
  static const Color gradientAltEnd = Color(0xFF9B4DDB);

  /// Star / shimmer highlight
  static const Color starHighlight = Color(0xCCFFFFFF);

  // ============================================
  // SEMANTIC COLORS
  // ============================================

  /// Success state
  static const Color success = Color(0xFF4ECB71);
  static const Color successBackground = Color(0xFF0F2E1E);
  static const Color successBackgroundLight = Color(0xFFE8F8ED);

  /// Warning state
  static const Color warning = Color(0xFFFFB020);
  static const Color warningBackground = Color(0xFF2E2510);
  static const Color warningBackgroundLight = Color(0xFFFFF8E6);

  /// Error state
  static const Color error = Color(0xFFFF5252);
  static const Color errorBackground = Color(0xFF2E0F1A);
  static const Color errorBackgroundLight = Color(0xFFFEECEC);

  /// Info state
  static const Color info = Color(0xFF7B61FF);
  static const Color infoBackground = Color(0xFF15104D);
  static const Color infoBackgroundLight = Color(0xFFECEAFF);

  // ============================================
  // ICON BUBBLE COLORS
  // ============================================

  /// Colors for circular icon backgrounds (dark theme)
  static const Color iconBubblePurple = Color(0xFF2D2B5A);
  static const Color iconBubbleGreen = Color(0xFF1A3A2A);
  static const Color iconBubbleOrange = Color(0xFF3A2A1A);
  static const Color iconBubbleBlue = Color(0xFF1A2A4A);
  static const Color iconBubblePink = Color(0xFF3A1A2D);

  /// Light theme icon bubbles
  static const Color iconBubblePurpleLight = Color(0xFFEDEAFF);
  static const Color iconBubbleGreenLight = Color(0xFFE8F8ED);
  static const Color iconBubbleOrangeLight = Color(0xFFFFF4E8);
  static const Color iconBubbleBlueLight = Color(0xFFE8EEFF);
  static const Color iconBubblePinkLight = Color(0xFFFEE8F0);

  // ============================================
  // NAVIGATION BAR COLORS
  // ============================================

  /// Bottom nav container background (dark)
  static const Color navContainerDark = Color(0xFF111540);

  /// Bottom nav container background (light)
  static const Color navContainerLight = Color(0xFFFFFFFF);

  /// Nav item active indicator
  static const Color navIndicator = Color(0xFF242966);
  static const Color navIndicatorLight = Color(0xFFEEEFF8);

  // ============================================
  // OVERLAY COLORS
  // ============================================

  /// Semi-transparent white overlay (ghost buttons, cards on dark BG)
  static const Color overlayWhiteSubtle = Color(0x26FFFFFF); // 15% opacity
  static const Color overlayWhiteMedium = Color(0x40FFFFFF); // 25% opacity

  /// Semi-transparent dark overlay
  static const Color overlayDark = Color(0x99000000);
}
