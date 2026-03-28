import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Primary, secondary, ghost, danger and gradient button variants.
/// Provides consistent button styling throughout the app.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.iconPosition = AppButtonIconPosition.leading,
    this.isLoading = false,
    this.isFullWidth = false,
    this.color,
    this.foregroundColor,
  });

  /// Button label text.
  final String label;

  /// Callback when button is pressed.
  final VoidCallback? onPressed;

  /// Button style variant.
  final AppButtonVariant variant;

  /// Button size.
  final AppButtonSize size;

  /// Optional icon.
  final IconData? icon;

  /// Icon position relative to label.
  final AppButtonIconPosition iconPosition;

  /// Shows loading indicator instead of content.
  final bool isLoading;

  /// Whether button should fill available width.
  final bool isFullWidth;

  /// Custom color (for primary variant).
  final Color? color;

  /// Custom foreground (text/icon) color for primary variant.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final metrics = _getMetrics();
    
    final Widget buttonContent = _buildContent(metrics);
    final bool isDisabled = onPressed == null || isLoading;

    Widget button;
    switch (variant) {
      case AppButtonVariant.primary:
        button = FilledButton(
          onPressed: isDisabled ? null : onPressed,
          style: _primaryStyle(metrics, isDark),
          child: buttonContent,
        );
        break;
      case AppButtonVariant.secondary:
        button = OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: _secondaryStyle(metrics, isDark),
          child: buttonContent,
        );
        break;
      case AppButtonVariant.ghost:
        button = TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: _ghostStyle(metrics, isDark),
          child: buttonContent,
        );
        break;
      case AppButtonVariant.danger:
        button = FilledButton(
          onPressed: isDisabled ? null : onPressed,
          style: _dangerStyle(metrics, isDark),
          child: buttonContent,
        );
        break;
      case AppButtonVariant.gradient:
        button = GradientButton(
          label: label,
          onPressed: isDisabled ? null : onPressed,
          size: size,
          icon: icon,
          iconPosition: iconPosition,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
        );
        // GradientButton already handles fullWidth internally, skip below.
        return button;
    }

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildContent(_ButtonMetrics metrics) {
    if (isLoading) {
      final loaderColor = variant == AppButtonVariant.primary || variant == AppButtonVariant.danger
          ? (foregroundColor ?? Colors.white)
          : AppColors.primary;
      return SizedBox(
        width: metrics.iconSize,
        height: metrics.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
        ),
      );
    }

    if (icon == null) {
      return Text(label);
    }

    final iconWidget = Icon(icon, size: metrics.iconSize);
    final gap = SizedBox(width: metrics.iconGap);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconPosition == AppButtonIconPosition.leading
          ? [iconWidget, gap, Text(label)]
          : [Text(label), gap, iconWidget],
    );
  }

  _ButtonMetrics _getMetrics() {
    switch (size) {
      case AppButtonSize.small:
        return const _ButtonMetrics(
          height: 40,
          horizontalPadding: AppSpacing.lg,
          verticalPadding: AppSpacing.sm,
          iconSize: 18,
          iconGap: AppSpacing.sm,
          fontSize: AppTypography.sizeSm,
        );
      case AppButtonSize.medium:
        return const _ButtonMetrics(
          height: 52,
          horizontalPadding: AppSpacing.xxl,
          verticalPadding: AppSpacing.md,
          iconSize: 20,
          iconGap: AppSpacing.sm,
          fontSize: AppTypography.sizeMd,
        );
      case AppButtonSize.large:
        return const _ButtonMetrics(
          height: 60,
          horizontalPadding: AppSpacing.xxxl,
          verticalPadding: AppSpacing.lg,
          iconSize: 24,
          iconGap: AppSpacing.md,
          fontSize: AppTypography.sizeLg,
        );
    }
  }

  ButtonStyle _primaryStyle(_ButtonMetrics metrics, bool isDark) {
    // Primary = white pill with dark text (matching the new design's onboarding buttons)
    final bgColor = color ?? Colors.white;
    final fgColor = foregroundColor ?? AppColors.darkBackground;
    return FilledButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      disabledBackgroundColor: isDark ? AppColors.darkElevated : AppColors.lightBorder,
      disabledForegroundColor: isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled,
      minimumSize: Size(0, metrics.height),
      padding: EdgeInsets.symmetric(
        horizontal: metrics.horizontalPadding,
        vertical: metrics.verticalPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderPill,
      ),
      textStyle: AppTypography.button.copyWith(fontSize: metrics.fontSize),
    );
  }

  ButtonStyle _secondaryStyle(_ButtonMetrics metrics, bool isDark) {
    // Secondary / ghost = translucent white border pill (dark) or subtle border (light)
    final borderColor = isDark ? AppColors.overlayWhiteSubtle : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    
    return OutlinedButton.styleFrom(
      foregroundColor: textColor,
      disabledForegroundColor: isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled,
      minimumSize: Size(0, metrics.height),
      padding: EdgeInsets.symmetric(
        horizontal: metrics.horizontalPadding,
        vertical: metrics.verticalPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderPill,
      ),
      side: BorderSide(color: borderColor, width: 1.0),
      textStyle: AppTypography.button.copyWith(fontSize: metrics.fontSize),
    );
  }

  ButtonStyle _ghostStyle(_ButtonMetrics metrics, bool isDark) {
    return TextButton.styleFrom(
      foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.primary,
      disabledForegroundColor: isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled,
      minimumSize: Size(0, metrics.height),
      padding: EdgeInsets.symmetric(
        horizontal: metrics.horizontalPadding,
        vertical: metrics.verticalPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderPill,
      ),
      textStyle: AppTypography.button.copyWith(fontSize: metrics.fontSize),
    );
  }

  ButtonStyle _dangerStyle(_ButtonMetrics metrics, bool isDark) {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.error,
      foregroundColor: Colors.white,
      disabledBackgroundColor: isDark ? AppColors.darkElevated : AppColors.lightBorder,
      disabledForegroundColor: isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled,
      minimumSize: Size(0, metrics.height),
      padding: EdgeInsets.symmetric(
        horizontal: metrics.horizontalPadding,
        vertical: metrics.verticalPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderPill,
      ),
      textStyle: AppTypography.button.copyWith(fontSize: metrics.fontSize),
    );
  }
}

/// Button variants.
enum AppButtonVariant {
  /// White pill with dark text – matches onboarding style ("Enable notifications", "Start Quiz").
  primary,

  /// Translucent white border pill – ghost style ("Not now", "Already have an account?").
  secondary,

  /// Text-only with no background.
  ghost,

  /// Red filled pill – destructive actions.
  danger,

  /// Purple → pink gradient pill – paywall/CTA style ("CONTINUE").
  gradient,
}

/// Button sizes.
enum AppButtonSize {
  small,
  medium,
  large,
}

/// Icon position in button.
enum AppButtonIconPosition {
  leading,
  trailing,
}

class _ButtonMetrics {
  const _ButtonMetrics({
    required this.height,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.iconGap,
    required this.fontSize,
  });

  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double iconGap;
  final double fontSize;
}

/// Icon-only button variants.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.variant = AppIconButtonVariant.filled,
    this.color,
    this.backgroundColor,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final AppIconButtonVariant variant;
  final Color? color;
  final Color? backgroundColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final metrics = _getMetrics();
    
    final effectiveIconColor = color ?? 
        (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);
    final effectiveBgColor = backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightCard);

    Widget button = Container(
      width: metrics.size,
      height: metrics.size,
      decoration: variant == AppIconButtonVariant.filled
          ? BoxDecoration(
              color: effectiveBgColor,
              shape: BoxShape.circle,
            )
          : null,
      child: IconButton(
        icon: Icon(icon, size: metrics.iconSize),
        onPressed: onPressed,
        color: effectiveIconColor,
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }

  _IconButtonMetrics _getMetrics() {
    switch (size) {
      case AppButtonSize.small:
        return const _IconButtonMetrics(size: 36, iconSize: 18);
      case AppButtonSize.medium:
        return const _IconButtonMetrics(size: 44, iconSize: 22);
      case AppButtonSize.large:
        return const _IconButtonMetrics(size: 52, iconSize: 26);
    }
  }
}

enum AppIconButtonVariant {
  filled,
  ghost,
}

class _IconButtonMetrics {
  const _IconButtonMetrics({
    required this.size,
    required this.iconSize,
  });

  final double size;
  final double iconSize;
}

// ============================================================
// GRADIENT BUTTON
// Purple → pink gradient pill button (CONTINUE / paywall CTA)
// ============================================================

/// A full-width or intrinsic-width pill button with a purple→pink gradient.
/// Use this for primary CTA actions on dark backgrounds (paywall, onboarding end).
class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.large,
    this.icon,
    this.iconPosition = AppButtonIconPosition.leading,
    this.isLoading = false,
    this.isFullWidth = true,
    this.gradientColors,
    this.hasShadow = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final IconData? icon;
  final AppButtonIconPosition iconPosition;
  final bool isLoading;
  final bool isFullWidth;

  /// Custom gradient overrides. Defaults to [gradientStart → gradientEnd].
  final List<Color>? gradientColors;

  /// Whether to render a purple glow shadow below the button.
  final bool hasShadow;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  double get _height {
    switch (widget.size) {
      case AppButtonSize.small:
        return 44;
      case AppButtonSize.medium:
        return 52;
      case AppButtonSize.large:
        return 58;
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case AppButtonSize.small:
        return AppTypography.sizeSm;
      case AppButtonSize.medium:
        return AppTypography.sizeMd;
      case AppButtonSize.large:
        return AppTypography.sizeLg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.gradientColors ??
        [AppColors.gradientStart, AppColors.gradientEnd];
    final isDisabled = widget.onPressed == null || widget.isLoading;

    Widget content;
    if (widget.isLoading) {
      content = const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (widget.icon != null) {
      final iconW = Icon(widget.icon, size: 20, color: Colors.white);
      final gap = const SizedBox(width: AppSpacing.sm);
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.iconPosition == AppButtonIconPosition.leading
            ? [iconW, gap, Text(widget.label)]
            : [Text(widget.label), gap, iconW],
      );
    } else {
      content = Text(widget.label);
    }

    final buttonDecoration = BoxDecoration(
      gradient: isDisabled
          ? null
          : LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: colors,
            ),
      color: isDisabled ? AppColors.darkElevated : null,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      boxShadow: (!isDisabled && widget.hasShadow)
          ? AppShadows.gradientGlow
          : null,
    );

    Widget button = GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: isDisabled ? null : (_) => setState(() => _pressed = false),
      onTapCancel: isDisabled ? null : () => setState(() => _pressed = false),
      onTap: isDisabled ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: _height,
          decoration: buttonDecoration,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.sm,
          ),
          child: DefaultTextStyle(
            style: AppTypography.button.copyWith(
              color: isDisabled ? AppColors.darkTextDisabled : Colors.white,
              fontSize: _fontSize,
              fontWeight: AppTypography.bold,
              letterSpacing: AppTypography.letterSpacingWider,
            ),
            child: Center(child: content),
          ),
        ),
      ),
    );

    if (widget.isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

