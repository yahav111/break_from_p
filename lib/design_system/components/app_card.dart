import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Premium rounded card with configurable elevation and padding.
/// Provides consistent card styling throughout the app.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation = AppCardElevation.none,
    this.border,
    this.onTap,
    this.onLongPress,
    this.clipBehavior = Clip.antiAlias,
    this.width,
    this.height,
  });

  /// Card content.
  final Widget child;

  /// Internal padding (defaults to AppSpacing.cardPadding).
  final EdgeInsets? padding;

  /// External margin.
  final EdgeInsets? margin;

  /// Background color (defaults to theme card color).
  final Color? backgroundColor;

  /// Border radius (defaults to AppRadius.card).
  final BorderRadius? borderRadius;

  /// Elevation level.
  final AppCardElevation elevation;

  /// Optional border.
  final Border? border;

  /// Tap callback for interactive cards.
  final VoidCallback? onTap;

  /// Long press callback.
  final VoidCallback? onLongPress;

  /// Clip behavior.
  final Clip clipBehavior;

  /// Fixed width.
  final double? width;

  /// Fixed height.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveBgColor = backgroundColor ??
        (isDark ? AppColors.darkCard : AppColors.lightCard);
    final effectiveRadius = borderRadius ?? AppRadius.card;
    final shadows = _getShadows(isDark);

    Widget cardContent = Padding(
      padding: padding ?? AppSpacing.cardPadding,
      child: child,
    );

    // Wrap with InkWell inside the card for proper ripple effect
    if (onTap != null || onLongPress != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: effectiveRadius,
          child: cardContent,
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: effectiveRadius,
        border: border,
        boxShadow: shadows,
      ),
      clipBehavior: clipBehavior,
      child: cardContent,
      );
  }

  List<BoxShadow> _getShadows(bool isDark) {
    switch (elevation) {
      case AppCardElevation.none:
        return AppShadows.none;
      case AppCardElevation.small:
        return isDark ? AppShadows.smDark : AppShadows.smLight;
      case AppCardElevation.medium:
        return isDark ? AppShadows.mdDark : AppShadows.mdLight;
      case AppCardElevation.large:
        return isDark ? AppShadows.lgDark : AppShadows.lgLight;
      case AppCardElevation.extraLarge:
        return isDark ? AppShadows.xlDark : AppShadows.xlLight;
    }
  }
}

/// Elevation levels for AppCard.
enum AppCardElevation {
  none,
  small,
  medium,
  large,
  extraLarge,
}

/// Variant of AppCard with a subtle border instead of shadow.
class AppBorderedCard extends StatelessWidget {
  const AppBorderedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.onTap,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveBorderColor = borderColor ??
        (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    return AppCard(
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      elevation: AppCardElevation.none,
      border: Border.all(
        color: effectiveBorderColor,
        width: 1,
      ),
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }
}

