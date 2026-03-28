import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../tokens/tokens.dart';
import 'app_card.dart';
import 'app_icon_circle.dart';

/// Metric display card with icon, value, and label.
/// Used for dashboards and statistics displays.
class AppStatsCard extends StatelessWidget {
  const AppStatsCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
    this.trend,
    this.trendValue,
    this.onTap,
    this.width,
    this.padding,
  });

  /// Main metric value.
  final String value;

  /// Description label.
  final String label;

  /// Optional icon.
  final IconData? icon;

  /// Icon color preset.
  final AppIconCircleColor? iconColor;

  /// Trend direction (up, down, neutral).
  final AppStatsTrend? trend;

  /// Trend percentage or value.
  final String? trendValue;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Fixed width.
  final double? width;

  /// Custom padding.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final valueColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return AppCard(
      width: width,
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          if (icon != null) ...[
            AppIconCircle(
              icon: icon!,
              size: AppIconCircleSize.medium,
              color: iconColor,
            ),
            AppSpacing.gapVerticalMd,
          ],

          // Value
          Text(
            value,
            style: AppTypography.statsValue.copyWith(color: valueColor),
            textAlign: TextAlign.center,
          ),

          AppSpacing.gapVerticalXs,

          // Label
          Text(
            label,
            style: AppTypography.statsLabel.copyWith(color: labelColor),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Trend
          if (trend != null && trendValue != null) ...[
            AppSpacing.gapVerticalSm,
            _TrendBadge(trend: trend!, value: trendValue!),
          ],
        ],
      ),
    );
  }
}

/// Horizontal stats card variant.
class AppStatsCardHorizontal extends StatelessWidget {
  const AppStatsCardHorizontal({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
    this.trend,
    this.trendValue,
    this.onTap,
  });

  final String value;
  final String label;
  final IconData? icon;
  final AppIconCircleColor? iconColor;
  final AppStatsTrend? trend;
  final String? trendValue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final valueColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: onTap,
      child: Row(
        children: [
          // Icon
          if (icon != null) ...[
            AppIconCircle(
              icon: icon!,
              size: AppIconCircleSize.large,
              color: iconColor,
            ),
            AppSpacing.gapLg,
          ],

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTypography.statsLabel.copyWith(color: labelColor),
                ),
                AppSpacing.gapVerticalXs,
                Text(
                  value,
                  style: AppTypography.titleLarge.copyWith(color: valueColor),
                ),
              ],
            ),
          ),

          // Trend
          if (trend != null && trendValue != null)
            _TrendBadge(trend: trend!, value: trendValue!),
        ],
      ),
    );
  }
}

/// Mini stats card for compact displays.
class AppMiniStatsCard extends StatelessWidget {
  const AppMiniStatsCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.color,
    this.onTap,
  });

  final String value;
  final String label;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final valueColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final iconColor = color ?? AppColors.primary;

    return AppBorderedCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: iconColor),
            AppSpacing.gapSm,
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTypography.labelLarge.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: AppTypography.caption.copyWith(color: labelColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({
    required this.trend,
    required this.value,
  });

  final AppStatsTrend trend;
  final String value;

  @override
  Widget build(BuildContext context) {
    final config = _getTrendConfig();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: AppRadius.borderPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 14, color: config.color),
          AppSpacing.gapXs,
          Text(
            value,
            style: AppTypography.labelSmall.copyWith(
              color: config.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _TrendConfig _getTrendConfig() {
    switch (trend) {
      case AppStatsTrend.up:
        return const _TrendConfig(
          icon: CupertinoIcons.arrow_up_right,
          color: AppColors.success,
          backgroundColor: Color(0x1A4ECB71),
        );
      case AppStatsTrend.down:
        return const _TrendConfig(
          icon: CupertinoIcons.arrow_down_right,
          color: AppColors.error,
          backgroundColor: Color(0x1AFF5252),
        );
      case AppStatsTrend.neutral:
        return const _TrendConfig(
          icon: CupertinoIcons.arrow_right,
          color: AppColors.warning,
          backgroundColor: Color(0x1AFFB020),
        );
    }
  }
}

/// Trend direction options.
enum AppStatsTrend {
  up,
  down,
  neutral,
}

class _TrendConfig {
  const _TrendConfig({
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;
}

