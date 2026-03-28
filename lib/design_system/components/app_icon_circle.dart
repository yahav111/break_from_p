import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Circular container for icons with background.
/// Used for icon bubbles in navigation, stats, and actions.
class AppIconCircle extends StatelessWidget {
  const AppIconCircle({
    super.key,
    required this.icon,
    this.size = AppIconCircleSize.medium,
    this.color,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
    this.badge,
    this.elevation = 0,
  });

  /// Icon to display.
  final IconData icon;

  /// Size preset.
  final AppIconCircleSize size;

  /// Semantic color (determines background and icon color).
  final AppIconCircleColor? color;

  /// Custom background color (overrides color preset).
  final Color? backgroundColor;

  /// Custom icon color (overrides color preset).
  final Color? iconColor;

  /// Tap callback for interactive icons.
  final VoidCallback? onTap;

  /// Optional badge widget to overlay.
  final Widget? badge;

  /// Shadow elevation.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final metrics = _getMetrics();
    final colors = _getColors(isDark);

    Widget circle = Container(
      width: metrics.containerSize,
      height: metrics.containerSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.background,
        shape: BoxShape.circle,
        boxShadow: elevation > 0
            ? AppShadows.getElevation(elevation.round(), theme.brightness)
            : null,
      ),
      child: Icon(
        icon,
        size: metrics.iconSize,
        color: iconColor ?? colors.icon,
      ),
    );

    if (onTap != null) {
      circle = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: circle,
        ),
      );
    }

    if (badge != null) {
      circle = Stack(
        clipBehavior: Clip.none,
        children: [
          circle,
          Positioned(
            top: -4,
            right: -4,
            child: badge!,
          ),
        ],
      );
    }

    return circle;
  }

  _IconCircleMetrics _getMetrics() {
    switch (size) {
      case AppIconCircleSize.small:
        return const _IconCircleMetrics(containerSize: 36, iconSize: 18);
      case AppIconCircleSize.medium:
        return const _IconCircleMetrics(containerSize: 48, iconSize: 24);
      case AppIconCircleSize.large:
        return const _IconCircleMetrics(containerSize: 56, iconSize: 28);
      case AppIconCircleSize.extraLarge:
        return const _IconCircleMetrics(containerSize: 72, iconSize: 36);
    }
  }

  _IconCircleColors _getColors(bool isDark) {
    if (color == null) {
      return _IconCircleColors(
        background: isDark ? AppColors.darkSurface : AppColors.lightCard,
        icon: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      );
    }

    switch (color!) {
      case AppIconCircleColor.primary:
        return _IconCircleColors(
          background: isDark ? AppColors.iconBubblePurple : AppColors.iconBubblePurpleLight,
          icon: AppColors.primary,
        );
      case AppIconCircleColor.secondary:
        return _IconCircleColors(
          background: isDark ? AppColors.iconBubbleGreen : AppColors.iconBubbleGreenLight,
          icon: AppColors.secondary,
        );
      case AppIconCircleColor.tertiary:
        return _IconCircleColors(
          background: isDark ? AppColors.iconBubbleOrange : AppColors.iconBubbleOrangeLight,
          icon: AppColors.tertiary,
        );
      case AppIconCircleColor.info:
        return _IconCircleColors(
          background: isDark ? AppColors.iconBubbleBlue : AppColors.iconBubbleBlueLight,
          icon: AppColors.info,
        );
      case AppIconCircleColor.success:
        return _IconCircleColors(
          background: isDark ? AppColors.successBackground : AppColors.successBackgroundLight,
          icon: AppColors.success,
        );
      case AppIconCircleColor.warning:
        return _IconCircleColors(
          background: isDark ? AppColors.warningBackground : AppColors.warningBackgroundLight,
          icon: AppColors.warning,
        );
      case AppIconCircleColor.error:
        return _IconCircleColors(
          background: isDark ? AppColors.errorBackground : AppColors.errorBackgroundLight,
          icon: AppColors.error,
        );
    }
  }
}

/// Size presets for AppIconCircle.
enum AppIconCircleSize {
  small,   // 36px
  medium,  // 48px
  large,   // 56px
  extraLarge, // 72px
}

/// Semantic color presets for AppIconCircle.
enum AppIconCircleColor {
  primary,
  secondary,
  tertiary,
  info,
  success,
  warning,
  error,
}

class _IconCircleMetrics {
  const _IconCircleMetrics({
    required this.containerSize,
    required this.iconSize,
  });

  final double containerSize;
  final double iconSize;
}

class _IconCircleColors {
  const _IconCircleColors({
    required this.background,
    required this.icon,
  });

  final Color background;
  final Color icon;
}

/// Badge widget for notification counts.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.count,
    this.color,
    this.maxCount = 99,
  });

  final int count;
  final Color? color;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    final displayText = count > maxCount ? '$maxCount+' : count.toString();
    final bgColor = color ?? AppColors.error;

    return Container(
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.borderCircular,
      ),
      child: Center(
        child: Text(
          displayText,
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

