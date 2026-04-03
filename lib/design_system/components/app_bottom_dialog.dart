import 'package:flutter/material.dart';

import '../tokens/tokens.dart';
import 'app_button.dart';

/// Bottom sheet dialog with primary and secondary buttons.
/// Opens from the bottom with consistent app styling.
class AppBottomDialog extends StatelessWidget {
  const AppBottomDialog({
    super.key,
    this.title,
    this.message,
    required this.primaryButtonLabel,
    this.secondaryButtonLabel,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.primaryButtonIcon,
    this.secondaryButtonIcon,
    this.isPrimaryLoading = false,
    this.isSecondaryLoading = false,
    this.isPrimaryDestructive = false,
    this.showHandle = true,
    this.content,
    this.buttonsInline = true,
  });

  /// Optional title text.
  final String? title;

  /// Optional message text.
  final String? message;

  /// Primary button label (required).
  final String primaryButtonLabel;

  /// Secondary button label (optional).
  final String? secondaryButtonLabel;

  /// Primary button press callback.
  final VoidCallback? onPrimaryPressed;

  /// Secondary button press callback.
  final VoidCallback? onSecondaryPressed;

  /// Optional icon for primary button.
  final IconData? primaryButtonIcon;

  /// Optional icon for secondary button.
  final IconData? secondaryButtonIcon;

  /// Whether primary button shows loading state.
  final bool isPrimaryLoading;

  /// Whether secondary button shows loading state.
  final bool isSecondaryLoading;

  /// Whether primary button should use danger variant.
  final bool isPrimaryDestructive;

  /// Whether to show drag handle at top.
  final bool showHandle;

  /// Optional custom content widget (replaces title/message).
  final Widget? content;

  /// Whether to show primary/secondary buttons in a single row.
  /// Default is vertical (stacked).
  final bool buttonsInline;

  /// Show the bottom dialog.
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    required String primaryButtonLabel,
    String? secondaryButtonLabel,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    IconData? primaryButtonIcon,
    IconData? secondaryButtonIcon,
    bool isPrimaryLoading = false,
    bool isSecondaryLoading = false,
    bool isPrimaryDestructive = false,
    bool showHandle = true,
    Widget? content,
    bool buttonsInline = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useRootNavigator = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomDialog(
        title: title,
        message: message,
        primaryButtonLabel: primaryButtonLabel,
        secondaryButtonLabel: secondaryButtonLabel,
        onPrimaryPressed: onPrimaryPressed != null
            ? () {
                onPrimaryPressed();
                Navigator.of(context).pop();
              }
            : null,
        onSecondaryPressed: onSecondaryPressed != null
            ? () {
                onSecondaryPressed();
                Navigator.of(context).pop();
              }
            : () => Navigator.of(context).pop(),
        primaryButtonIcon: primaryButtonIcon,
        secondaryButtonIcon: secondaryButtonIcon,
        isPrimaryLoading: isPrimaryLoading,
        isSecondaryLoading: isSecondaryLoading,
        isPrimaryDestructive: isPrimaryDestructive,
        showHandle: showHandle,
        content: content,
        buttonsInline: buttonsInline,
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
    final messageColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final mediaQuery = MediaQuery.of(context);

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: Container(
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

            // Content
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                secondaryButtonLabel != null ? AppSpacing.md : AppSpacing.lg,
              ),
              child: content ??
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (title != null) ...[
                        Text(
                          title!,
                          style: AppTypography.titleMedium.copyWith(color: titleColor),
                          textAlign: TextAlign.center,
                        ),
                        if (message != null) AppSpacing.gapVerticalSm,
                      ],
                      if (message != null)
                        Text(
                          message!,
                          style: AppTypography.bodyMedium.copyWith(color: messageColor),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: (buttonsInline && secondaryButtonLabel != null)
                  ? Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: primaryButtonLabel,
                            onPressed: onPrimaryPressed,
                            variant: isPrimaryDestructive
                                ? AppButtonVariant.danger
                                : AppButtonVariant.primary,
                            size: AppButtonSize.medium,
                            icon: primaryButtonIcon,
                            isLoading: isPrimaryLoading,
                            isFullWidth: true,
                          ),
                        ),
                        AppSpacing.gapSm,
                        Expanded(
                          child: AppButton(
                            label: secondaryButtonLabel!,
                            onPressed: onSecondaryPressed,
                            variant: AppButtonVariant.secondary,
                            size: AppButtonSize.medium,
                            icon: secondaryButtonIcon,
                            isLoading: isSecondaryLoading,
                            isFullWidth: true,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Primary button
                        AppButton(
                          label: primaryButtonLabel,
                          onPressed: onPrimaryPressed,
                          variant: isPrimaryDestructive
                              ? AppButtonVariant.danger
                              : AppButtonVariant.primary,
                          size: AppButtonSize.medium,
                          icon: primaryButtonIcon,
                          isLoading: isPrimaryLoading,
                          isFullWidth: true,
                        ),
                        // Secondary button (if provided)
                        if (secondaryButtonLabel != null) ...[
                          AppSpacing.gapVerticalSm,
                          AppButton(
                            label: secondaryButtonLabel!,
                            onPressed: onSecondaryPressed,
                            variant: AppButtonVariant.secondary,
                            size: AppButtonSize.medium,
                            icon: secondaryButtonIcon,
                            isLoading: isSecondaryLoading,
                            isFullWidth: true,
                          ),
                        ],
                      ],
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

