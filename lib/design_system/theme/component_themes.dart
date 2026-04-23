import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Widget-specific theme configurations.
/// These extend the base FlexColorScheme theme with custom styling.
class ComponentThemes {
  ComponentThemes._();

  // ============================================
  // APP BAR THEME
  // ============================================

  static AppBarTheme appBarTheme({required bool isDark}) {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      titleTextStyle: AppTypography.titleMedium.copyWith(
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      iconTheme: IconThemeData(
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        size: 24,
      ),
    );
  }

  // ============================================
  // CARD THEME
  // ============================================

  static CardThemeData cardTheme({required bool isDark}) {
    return CardThemeData(
      elevation: 0,
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    );
  }

  // ============================================
  // BOTTOM NAVIGATION BAR THEME
  // ============================================

  static BottomNavigationBarThemeData bottomNavTheme({required bool isDark}) {
    return BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: isDark ? AppColors.navContainerDark : AppColors.navContainerLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
      selectedLabelStyle: AppTypography.navItem,
      unselectedLabelStyle: AppTypography.navItem,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }

  // ============================================
  // NAVIGATION BAR THEME (Material 3)
  // ============================================

  static NavigationBarThemeData navigationBarTheme({required bool isDark}) {
    return NavigationBarThemeData(
      elevation: 0,
      backgroundColor: isDark ? AppColors.navContainerDark : AppColors.navContainerLight,
      surfaceTintColor: Colors.transparent,
      indicatorColor: isDark ? AppColors.navIndicator : AppColors.navIndicatorLight,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.navItem.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          );
        }
        return AppTypography.navItem.copyWith(
          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: AppColors.primary,
            size: 24,
          );
        }
        return IconThemeData(
          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          size: 24,
        );
      }),
      height: 72,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  // ============================================
  // INPUT DECORATION THEME
  // ============================================

  static InputDecorationTheme inputDecorationTheme({required bool isDark}) {
    final fillColor = isDark ? AppColors.darkSurface : AppColors.lightCard;
    final hintColor = isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(color: hintColor),
      labelStyle: AppTypography.bodyMedium.copyWith(color: hintColor),
      floatingLabelStyle: AppTypography.labelMedium.copyWith(color: AppColors.primary),
      prefixIconColor: hintColor,
      suffixIconColor: hintColor,
      border: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide.none,
      ),
      errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
    );
  }

  // ============================================
  // ELEVATED BUTTON THEME
  // Primary button = white pill with dark text (onboarding style)
  // ============================================

  static ElevatedButtonThemeData elevatedButtonTheme({required bool isDark}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkBackground,
        disabledBackgroundColor: isDark ? AppColors.darkElevated : AppColors.lightBorder,
        disabledForegroundColor: isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        ),
        minimumSize: const Size(double.minPositive, 56),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderPill,
        ),
        textStyle: AppTypography.button.copyWith(
          fontWeight: AppTypography.semiBold,
          fontSize: AppTypography.sizeLg,
        ),
      ),
    );
  }

  // ============================================
  // FILLED BUTTON THEME
  // Secondary filled = primary purple pill
  // ============================================

  static FilledButtonThemeData filledButtonTheme({required bool isDark}) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: isDark ? AppColors.darkElevated : AppColors.lightBorder,
        disabledForegroundColor: isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        ),
        minimumSize: const Size(double.minPositive, 56),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderPill,
        ),
        textStyle: AppTypography.button.copyWith(
          fontWeight: AppTypography.semiBold,
          fontSize: AppTypography.sizeLg,
        ),
      ),
    );
  }

  // ============================================
  // OUTLINED BUTTON THEME
  // Ghost button = translucent white border, white text, pill shape
  // ============================================

  static OutlinedButtonThemeData outlinedButtonTheme({required bool isDark}) {
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final borderColor = isDark
        ? AppColors.overlayWhiteSubtle
        : AppColors.lightBorder;

    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: textColor,
        disabledForegroundColor: isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        ),
        minimumSize: const Size(double.minPositive, 52),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderPill,
        ),
        side: BorderSide(color: borderColor, width: 1.0),
        textStyle: AppTypography.button,
      ),
    );
  }

  // ============================================
  // TEXT BUTTON THEME
  // ============================================

  static TextButtonThemeData textButtonTheme({required bool isDark}) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        elevation: 0,
        foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.primary,
        disabledForegroundColor: isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        minimumSize: const Size(double.minPositive, 44),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderPill,
        ),
        textStyle: AppTypography.button,
      ),
    );
  }

  // ============================================
  // ICON BUTTON THEME
  // ============================================

  static IconButtonThemeData iconButtonTheme({required bool isDark}) {
    final backgroundColor = isDark
        ? AppColors.overlayWhiteSubtle
        : AppColors.lightCard;
    final iconColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return IconButtonThemeData(
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: iconColor,
        disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
        disabledForegroundColor: iconColor.withValues(alpha: 0.3),
        padding: const EdgeInsets.all(AppSpacing.md),
        minimumSize: const Size(44, 44),
        shape: const CircleBorder(),
        iconSize: 24,
      ),
    );
  }

  // ============================================
  // CHIP THEME
  // ============================================

  static ChipThemeData chipTheme({required bool isDark}) {
    final backgroundColor = isDark ? AppColors.darkSurface : AppColors.lightCard;
    final labelColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return ChipThemeData(
      backgroundColor: backgroundColor,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      disabledColor: backgroundColor.withValues(alpha: 0.5),
      labelStyle: AppTypography.labelMedium.copyWith(color: labelColor),
      secondaryLabelStyle: AppTypography.labelMedium,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.chip,
      ),
      side: BorderSide.none,
      showCheckmark: false,
    );
  }

  // ============================================
  // BOTTOM SHEET THEME
  // ============================================

  static BottomSheetThemeData bottomSheetTheme({required bool isDark}) {
    return BottomSheetThemeData(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalBackgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      modalElevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.modal,
      ),
      dragHandleColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      dragHandleSize: const Size(40, 4),
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: 640),
    );
  }

  // ============================================
  // LIST TILE THEME
  // ============================================

  static ListTileThemeData listTileTheme({required bool isDark}) {
    return ListTileThemeData(
      contentPadding: AppSpacing.listItemPadding,
      minVerticalPadding: AppSpacing.md,
      horizontalTitleGap: AppSpacing.lg,
      tileColor: Colors.transparent,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
      iconColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      textColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      titleTextStyle: AppTypography.bodyLarge.copyWith(
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      subtitleTextStyle: AppTypography.bodySmall.copyWith(
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
      leadingAndTrailingTextStyle: AppTypography.bodySmall,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderMedium,
      ),
      dense: false,
      visualDensity: VisualDensity.standard,
    );
  }

  // ============================================
  // DIALOG THEME
  // ============================================

  static DialogTheme dialogTheme({required bool isDark}) {
    return DialogTheme(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderExtraLarge,
      ),
      titleTextStyle: AppTypography.titleMedium.copyWith(
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
    );
  }

  // ============================================
  // SNACK BAR THEME
  // ============================================

  static SnackBarThemeData snackBarTheme({required bool isDark}) {
    return SnackBarThemeData(
      backgroundColor: isDark ? AppColors.darkElevated : AppColors.lightTextPrimary,
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightBackground,
      ),
      actionTextColor: AppColors.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderMedium,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      insetPadding: AppSpacing.allLg,
    );
  }

  // ============================================
  // DIVIDER THEME
  // ============================================

  static DividerThemeData dividerTheme({required bool isDark}) {
    return DividerThemeData(
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      thickness: 1,
      space: 1,
      indent: 0,
      endIndent: 0,
    );
  }

  // ============================================
  // GRADIENT BUTTON DECORATION (helper)
  // Use with InkWell + Ink / GestureDetector when a gradient
  // CTA button (purple → pink) is needed.
  // ============================================

  /// BoxDecoration for a gradient pill CTA button (e.g. "CONTINUE" paywall button).
  static BoxDecoration gradientButtonDecoration({
    double borderRadius = AppRadius.pill,
    bool hasShadow = true,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: AlignmentDirectional.centerStart,
        end: AlignmentDirectional.centerEnd,
        colors: [AppColors.gradientStart, AppColors.gradientEnd],
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: hasShadow ? AppShadows.gradientGlow : null,
    );
  }

  /// Minimum-size / padding style for gradient button content.
  static const EdgeInsets gradientButtonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.xxl,
    vertical: AppSpacing.lg,
  );

  /// Text style for gradient button label.
  static TextStyle get gradientButtonTextStyle => AppTypography.button.copyWith(
        color: Colors.white,
        fontWeight: AppTypography.bold,
        fontSize: AppTypography.sizeLg,
        letterSpacing: AppTypography.letterSpacingWider,
      );
}
