import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Section header with title, optional action, and accent bar.
/// Used to separate and label content sections.
class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.actionLabel,
    this.onActionTap,
    this.showAccent = true,
    this.accentColor,
    this.padding,
  });

  /// Section title text.
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  /// Optional trailing action widget.
  final Widget? action;

  /// Text label for the action (alternative to custom action widget).
  final String? actionLabel;

  /// Callback when action is tapped.
  final VoidCallback? onActionTap;

  /// Whether to show the accent bar.
  final bool showAccent;

  /// Custom accent color.
  final Color? accentColor;

  /// Custom padding.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final effectiveAccentColor = accentColor ?? AppColors.primary;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Accent bar
          if (showAccent) ...[
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: effectiveAccentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AppSpacing.gapMd,
          ],

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(color: titleColor),
                ),
                if (subtitle != null) ...[
                  AppSpacing.gapVerticalXs,
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(color: subtitleColor),
                  ),
                ],
              ],
            ),
          ),

          // Action
          if (action != null) action!,
          if (actionLabel != null)
            TextButton(
              onPressed: onActionTap,
              child: Text(
                actionLabel!,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Simple section divider with optional label.
class AppSectionDivider extends StatelessWidget {
  const AppSectionDivider({
    super.key,
    this.label,
    this.margin,
  });

  final String? label;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;

    if (label == null) {
      return Padding(
        padding: margin ?? AppSpacing.verticalLg,
        child: Divider(color: dividerColor, height: 1),
      );
    }

    return Padding(
      padding: margin ?? AppSpacing.verticalLg,
      child: Row(
        children: [
          Expanded(child: Divider(color: dividerColor, height: 1)),
          Padding(
            padding: AppSpacing.horizontalMd,
            child: Text(
              label!,
              style: AppTypography.caption.copyWith(color: textColor),
            ),
          ),
          Expanded(child: Divider(color: dividerColor, height: 1)),
        ],
      ),
    );
  }
}

