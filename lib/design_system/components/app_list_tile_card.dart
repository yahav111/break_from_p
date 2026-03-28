import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../tokens/tokens.dart';
import 'app_card.dart';
import 'app_icon_circle.dart';

/// Card-wrapped list item with leading, title, subtitle, and trailing.
/// Provides consistent list item styling with card appearance.
class AppListTileCard extends StatelessWidget {
  const AppListTileCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.leadingIcon,
    this.leadingIconColor,
    this.trailingIcon,
    this.showChevron = false,
    this.padding,
    this.margin,
    this.elevation = AppCardElevation.none,
    this.isEnabled = true,
  });

  /// Primary title text.
  final String title;

  /// Secondary subtitle text.
  final String? subtitle;

  /// Custom leading widget.
  final Widget? leading;

  /// Custom trailing widget.
  final Widget? trailing;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Long press callback.
  final VoidCallback? onLongPress;

  /// Icon for auto-generated leading widget.
  final IconData? leadingIcon;

  /// Color for leading icon.
  final AppIconCircleColor? leadingIconColor;

  /// Icon for trailing (alternative to trailing widget).
  final IconData? trailingIcon;

  /// Whether to show chevron arrow in trailing.
  final bool showChevron;

  /// Internal padding.
  final EdgeInsets? padding;

  /// External margin.
  final EdgeInsets? margin;

  /// Card elevation.
  final AppCardElevation elevation;

  /// Whether the item is enabled.
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final disabledColor = isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled;
    final chevronColor = isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;

    Widget? leadingWidget = leading;
    if (leadingWidget == null && leadingIcon != null) {
      leadingWidget = AppIconCircle(
        icon: leadingIcon!,
        size: AppIconCircleSize.medium,
        color: leadingIconColor,
      );
    }

    Widget? trailingWidget = trailing;
    if (trailingWidget == null) {
      if (trailingIcon != null) {
        trailingWidget = Icon(
          trailingIcon,
          color: isEnabled ? chevronColor : disabledColor,
          size: 22,
        );
      } else if (showChevron) {
        trailingWidget = Icon(
          CupertinoIcons.chevron_right,
          color: isEnabled ? chevronColor : disabledColor,
          size: 24,
        );
      }
    }

    return AppCard(
      margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.md),
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      elevation: elevation,
      onTap: isEnabled ? onTap : null,
      onLongPress: isEnabled ? onLongPress : null,
      child: Row(
        children: [
          if (leadingWidget != null) ...[
            leadingWidget,
            AppSpacing.gapLg,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    color: isEnabled ? titleColor : disabledColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  AppSpacing.gapVerticalXs,
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: isEnabled ? subtitleColor : disabledColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailingWidget != null) ...[
            AppSpacing.gapMd,
            trailingWidget,
          ],
        ],
      ),
    );
  }
}

/// Simple list tile without card wrapper.
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.leadingIcon,
    this.leadingIconColor,
    this.showChevron = false,
    this.showDivider = false,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  final AppIconCircleColor? leadingIconColor;
  final bool showChevron;
  final bool showDivider;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final chevronColor = isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;
    final dividerColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    Widget? leadingWidget = leading;
    if (leadingWidget == null && leadingIcon != null) {
      leadingWidget = AppIconCircle(
        icon: leadingIcon!,
        size: AppIconCircleSize.medium,
        color: leadingIconColor,
      );
    }

    Widget? trailingWidget = trailing;
    if (trailingWidget == null && showChevron) {
      trailingWidget = Icon(
        CupertinoIcons.chevron_right,
        color: chevronColor,
        size: 24,
      );
    }

    Widget content = Padding(
      padding: padding ?? AppSpacing.listItemPadding,
      child: Row(
        children: [
          if (leadingWidget != null) ...[
            leadingWidget,
            AppSpacing.gapLg,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(color: titleColor),
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
          if (trailingWidget != null) ...[
            AppSpacing.gapMd,
            trailingWidget,
          ],
        ],
      ),
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: content,
        ),
      );
    }

    if (showDivider) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          Divider(color: dividerColor, height: 1, indent: AppSpacing.lg),
        ],
      );
    }

    return content;
  }
}

