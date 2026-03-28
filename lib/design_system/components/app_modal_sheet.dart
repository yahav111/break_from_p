import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Bottom sheet with rounded top corners.
/// Provides consistent modal sheet styling.
class AppModalSheet extends StatelessWidget {
  const AppModalSheet({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.showHandle = true,
    this.showCloseButton = false,
    this.onClose,
    this.actions,
    this.padding,
    this.maxHeight,
    this.minHeight,
  });

  /// Sheet content.
  final Widget child;

  /// Optional title.
  final String? title;

  /// Optional subtitle.
  final String? subtitle;

  /// Whether to show the drag handle.
  final bool showHandle;

  /// Whether to show close button.
  final bool showCloseButton;

  /// Close callback.
  final VoidCallback? onClose;

  /// Optional action buttons in header.
  final List<Widget>? actions;

  /// Content padding.
  final EdgeInsets? padding;

  /// Maximum height as fraction of screen.
  final double? maxHeight;

  /// Minimum height.
  final double? minHeight;

  /// Show the modal sheet.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    String? subtitle,
    bool showHandle = true,
    bool showCloseButton = false,
    List<Widget>? actions,
    EdgeInsets? padding,
    double? maxHeight,
    double? minHeight,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      backgroundColor: Colors.transparent,
      builder: (context) => AppModalSheet(
        title: title,
        subtitle: subtitle,
        showHandle: showHandle,
        showCloseButton: showCloseButton,
        onClose: () => Navigator.of(context).pop(),
        actions: actions,
        padding: padding,
        maxHeight: maxHeight,
        minHeight: minHeight,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final handleColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final mediaQuery = MediaQuery.of(context);
    final effectiveMaxHeight = maxHeight ?? 0.9;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * effectiveMaxHeight,
          minHeight: minHeight ?? 0,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadius.modal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            if (showHandle)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: handleColor,
                    borderRadius: AppRadius.borderCircular,
                  ),
                ),
              ),

            // Header
            if (title != null || showCloseButton || actions != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    if (showCloseButton)
                      IconButton(
                        icon: const Icon(CupertinoIcons.xmark),
                        onPressed: onClose,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    if (showCloseButton && title != null) AppSpacing.gapSm,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null)
                            Text(
                              title!,
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
                    if (actions != null) ...actions!,
                  ],
                ),
              ),

            // Content
            Flexible(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
              child: child is ScrollView
                  ? child
                  : SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: child,
                    ),
            ),
            ),

            // Bottom safe area
            SizedBox(height: mediaQuery.padding.bottom),
          ],
        ),
      ),
    );
  }
}

/// Confirmation dialog sheet.
class AppConfirmSheet extends StatelessWidget {
  const AppConfirmSheet({
    super.key,
    required this.title,
    this.message,
    this.confirmLabel,
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  final String title;
  final String? message;
  final String? confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    String? message,
    String? confirmLabel,
    String? cancelLabel,
    bool isDestructive = false,
  }) {
    return AppModalSheet.show<bool>(
      context: context,
      showCloseButton: false,
      child: AppConfirmSheet(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final messageColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(color: titleColor),
          textAlign: TextAlign.center,
        ),
        if (message != null) ...[
          AppSpacing.gapVerticalMd,
          Text(
            message!,
            style: AppTypography.bodyMedium.copyWith(color: messageColor),
            textAlign: TextAlign.center,
          ),
        ],
        AppSpacing.gapVerticalXxl,
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.borderMedium,
                  ),
                ),
                child: Text(cancelLabel ?? 'Cancel'),
              ),
            ),
            AppSpacing.gapMd,
            Expanded(
              child: FilledButton(
                onPressed: onConfirm,
                style: FilledButton.styleFrom(
                  backgroundColor: isDestructive ? AppColors.error : AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.borderMedium,
                  ),
                ),
                child: Text(confirmLabel ?? 'Confirm'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Action sheet with list of options.
class AppActionSheet extends StatelessWidget {
  const AppActionSheet({
    super.key,
    required this.actions,
    this.title,
    this.cancelLabel,
  });

  final List<AppActionSheetItem> actions;
  final String? title;
  final String? cancelLabel;

  static Future<int?> show({
    required BuildContext context,
    required List<AppActionSheetItem> actions,
    String? title,
    String? cancelLabel,
  }) {
    return AppModalSheet.show<int>(
      context: context,
      title: title,
      padding: EdgeInsets.zero,
      child: AppActionSheet(
        actions: actions,
        title: title,
        cancelLabel: cancelLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(actions.length, (index) {
          final action = actions[index];
          final isLast = index == actions.length - 1;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: action.icon != null
                    ? Icon(
                        action.icon,
                        color: action.isDestructive
                            ? AppColors.error
                            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      )
                    : null,
                title: Text(
                  action.label,
                  style: AppTypography.bodyLarge.copyWith(
                    color: action.isDestructive
                        ? AppColors.error
                        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(index);
                  action.onTap?.call();
                },
              ),
              if (!isLast) Divider(height: 1, color: dividerColor),
            ],
          );
        }),
        if (cancelLabel != null) ...[
          AppSpacing.gapVerticalSm,
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                ),
                child: Text(cancelLabel!),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Action sheet item data.
class AppActionSheetItem {
  const AppActionSheetItem({
    required this.label,
    this.icon,
    this.onTap,
    this.isDestructive = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isDestructive;
}

