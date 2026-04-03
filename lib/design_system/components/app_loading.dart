import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Reusable loading indicator widget with multiple variants and sizes.
/// Provides consistent loading states throughout the app.
class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.variant = AppLoadingVariant.circular,
    this.size = AppLoadingSize.medium,
    this.color,
    this.backgroundColor,
    this.message,
    this.messageStyle,
  });

  /// Loading indicator variant.
  final AppLoadingVariant variant;

  /// Size of the loading indicator.
  final AppLoadingSize size;

  /// Custom color for the indicator (defaults to primary color).
  final Color? color;

  /// Background color (for overlay variant).
  final Color? backgroundColor;

  /// Optional message to display below the indicator.
  final String? message;

  /// Custom text style for the message.
  final TextStyle? messageStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final metrics = _getMetrics();
    final effectiveColor = color ?? AppColors.primary;

    Widget indicator;
    switch (variant) {
      case AppLoadingVariant.circular:
        indicator = CircularProgressIndicator(
          strokeWidth: metrics.strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
        );
        break;
      case AppLoadingVariant.linear:
        indicator = LinearProgressIndicator(
          minHeight: metrics.strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          backgroundColor: isDark
              ? AppColors.darkBorder
              : AppColors.lightBorder,
        );
        break;
    }

    if (message != null) {
      final effectiveTextStyle = messageStyle ??
          AppTypography.bodyMedium.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          );

      indicator = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: metrics.size,
            height: metrics.size,
            child: indicator,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            message!,
            style: effectiveTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      indicator = SizedBox(
        width: metrics.size,
        height: metrics.size,
        child: indicator,
      );
    }

    return indicator;
  }

  _LoadingMetrics _getMetrics() {
    switch (size) {
      case AppLoadingSize.small:
        return const _LoadingMetrics(
          size: 24,
          strokeWidth: 2.5,
        );
      case AppLoadingSize.medium:
        return const _LoadingMetrics(
          size: 40,
          strokeWidth: 3.5,
        );
      case AppLoadingSize.large:
        return const _LoadingMetrics(
          size: 56,
          strokeWidth: 4.5,
        );
    }
  }
}

/// Full-screen loading overlay with optional message.
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor,
    this.color,
    this.size = AppLoadingSize.medium,
  });

  /// Optional message to display.
  final String? message;

  /// Background color (defaults to semi-transparent black/white).
  final Color? backgroundColor;

  /// Loading indicator color.
  final Color? color;

  /// Size of the loading indicator.
  final AppLoadingSize size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveBgColor = backgroundColor ??
        (isDark
            ? Colors.black.withOpacity(0.7)
            : Colors.white.withOpacity(0.9));

    return Container(
      color: effectiveBgColor,
      child: Center(
        child: AppLoading(
          variant: AppLoadingVariant.circular,
          size: size,
          color: color,
          message: message,
        ),
      ),
    );
  }
}

/// Loading indicator that fills available space.
class AppLoadingFill extends StatelessWidget {
  const AppLoadingFill({
    super.key,
    this.variant = AppLoadingVariant.circular,
    this.color,
    this.message,
  });

  /// Loading indicator variant.
  final AppLoadingVariant variant;

  /// Custom color for the indicator.
  final Color? color;

  /// Optional message to display.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppLoading(
        variant: variant,
        size: AppLoadingSize.medium,
        color: color,
        message: message,
      ),
    );
  }
}

/// Loading indicator variants.
enum AppLoadingVariant {
  /// Circular progress indicator.
  circular,

  /// Linear progress indicator.
  linear,
}

/// Loading indicator sizes.
enum AppLoadingSize {
  small,
  medium,
  large,
}

class _LoadingMetrics {
  const _LoadingMetrics({
    required this.size,
    required this.strokeWidth,
  });

  final double size;
  final double strokeWidth;
}

