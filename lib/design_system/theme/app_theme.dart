import 'package:flutter/material.dart';

import '../tokens/tokens.dart';
import 'component_themes.dart';

/// App theme configuration using pure Flutter Material 3.
/// Provides consistent theming for the entire application.
class AppTheme {
  AppTheme._();

  // ============================================
  // DARK THEME
  // ============================================

  /// Complete dark theme configuration – Night Sky / Deep Space
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: Colors.white,
      tertiary: AppColors.tertiary,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.tertiaryDark,
      onTertiaryContainer: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.errorBackground,
      onErrorContainer: AppColors.error,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkElevated,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkBorderSubtle,
      shadow: const Color(0xFF000000),
      scrim: AppColors.overlayDark,
      inverseSurface: AppColors.lightTextPrimary,
      onInverseSurface: AppColors.darkTextPrimary,
      inversePrimary: AppColors.primaryDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      fontFamily: AppTypography.fontFamily,
      // Component-level overrides
      appBarTheme: ComponentThemes.appBarTheme(isDark: true),
      cardTheme: ComponentThemes.cardTheme(isDark: true),
      bottomNavigationBarTheme: ComponentThemes.bottomNavTheme(isDark: true),
      navigationBarTheme: ComponentThemes.navigationBarTheme(isDark: true),
      inputDecorationTheme: ComponentThemes.inputDecorationTheme(isDark: true),
      elevatedButtonTheme: ComponentThemes.elevatedButtonTheme(isDark: true),
      filledButtonTheme: ComponentThemes.filledButtonTheme(isDark: true),
      outlinedButtonTheme: ComponentThemes.outlinedButtonTheme(isDark: true),
      textButtonTheme: ComponentThemes.textButtonTheme(isDark: true),
      iconButtonTheme: ComponentThemes.iconButtonTheme(isDark: true),
      chipTheme: ComponentThemes.chipTheme(isDark: true),
      bottomSheetTheme: ComponentThemes.bottomSheetTheme(isDark: true),
      listTileTheme: ComponentThemes.listTileTheme(isDark: true),
      dividerTheme: ComponentThemes.dividerTheme(isDark: true),
      snackBarTheme: ComponentThemes.snackBarTheme(isDark: true),
      textTheme: _buildTextTheme(isDark: true),
      // Global defaults
      dividerColor: AppColors.darkBorder,
      cardColor: AppColors.darkCard,
      splashColor: AppColors.primary.withValues(alpha: 0.1),
      highlightColor: AppColors.primary.withValues(alpha: 0.05),
    );
  }

  // ============================================
  // LIGHT THEME
  // ============================================

  /// Complete light theme configuration
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.secondaryDark,
      tertiary: AppColors.tertiary,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.tertiaryLight,
      onTertiaryContainer: AppColors.tertiaryDark,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.errorBackgroundLight,
      onErrorContainer: AppColors.error,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerHighest: AppColors.lightCard,
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: AppColors.lightBorder,
      outlineVariant: AppColors.lightBorderSubtle,
      shadow: const Color(0xFF000000),
      scrim: AppColors.overlayDark,
      inverseSurface: AppColors.lightTextPrimary,
      onInverseSurface: AppColors.lightBackground,
      inversePrimary: AppColors.primaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      fontFamily: AppTypography.fontFamily,
      // Component-level overrides
      appBarTheme: ComponentThemes.appBarTheme(isDark: false),
      cardTheme: ComponentThemes.cardTheme(isDark: false),
      bottomNavigationBarTheme: ComponentThemes.bottomNavTheme(isDark: false),
      navigationBarTheme: ComponentThemes.navigationBarTheme(isDark: false),
      inputDecorationTheme: ComponentThemes.inputDecorationTheme(isDark: false),
      elevatedButtonTheme: ComponentThemes.elevatedButtonTheme(isDark: false),
      filledButtonTheme: ComponentThemes.filledButtonTheme(isDark: false),
      outlinedButtonTheme: ComponentThemes.outlinedButtonTheme(isDark: false),
      textButtonTheme: ComponentThemes.textButtonTheme(isDark: false),
      iconButtonTheme: ComponentThemes.iconButtonTheme(isDark: false),
      chipTheme: ComponentThemes.chipTheme(isDark: false),
      bottomSheetTheme: ComponentThemes.bottomSheetTheme(isDark: false),
      listTileTheme: ComponentThemes.listTileTheme(isDark: false),
      dividerTheme: ComponentThemes.dividerTheme(isDark: false),
      snackBarTheme: ComponentThemes.snackBarTheme(isDark: false),
      textTheme: _buildTextTheme(isDark: false),
      // Global defaults
      dividerColor: AppColors.lightBorder,
      cardColor: AppColors.lightCard,
      splashColor: AppColors.primary.withValues(alpha: 0.1),
      highlightColor: AppColors.primary.withValues(alpha: 0.05),
    );
  }

  // ============================================
  // TEXT THEME
  // ============================================

  static TextTheme _buildTextTheme({required bool isDark}) {
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return TextTheme(
      displayLarge: AppTypography.headlineXl.copyWith(color: textColor),
      displayMedium: AppTypography.headlineLarge.copyWith(color: textColor),
      displaySmall: AppTypography.headlineMedium.copyWith(color: textColor),
      headlineLarge: AppTypography.headlineLarge.copyWith(color: textColor),
      headlineMedium: AppTypography.headlineMedium.copyWith(color: textColor),
      headlineSmall: AppTypography.titleLarge.copyWith(color: textColor),
      titleLarge: AppTypography.titleLarge.copyWith(color: textColor),
      titleMedium: AppTypography.titleMedium.copyWith(color: textColor),
      titleSmall: AppTypography.titleSmall.copyWith(color: textColor),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: textColor),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: textColor),
      bodySmall: AppTypography.bodySmall.copyWith(color: secondaryColor),
      labelLarge: AppTypography.labelLarge.copyWith(color: textColor),
      labelMedium: AppTypography.labelMedium.copyWith(color: secondaryColor),
      labelSmall: AppTypography.labelSmall.copyWith(color: secondaryColor),
    );
  }
}
