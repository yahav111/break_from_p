import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Full-rounded search bar with soft background.
/// Provides consistent search input styling.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = true,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction = TextInputAction.search,
    this.focusNode,
  });

  /// Text controller.
  final TextEditingController? controller;

  /// Hint text displayed when empty.
  final String? hintText;

  /// Called when text changes.
  final ValueChanged<String>? onChanged;

  /// Called when search is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Called when clear button is pressed.
  final VoidCallback? onClear;

  /// Custom prefix icon (defaults to search icon).
  final IconData? prefixIcon;

  /// Custom suffix icon (replaces clear button).
  final Widget? suffixIcon;

  /// Whether to show clear button when text is present.
  final bool showClearButton;

  /// Whether the search bar is enabled.
  final bool enabled;

  /// Whether to autofocus on mount.
  final bool autofocus;

  /// Keyboard action button.
  final TextInputAction textInputAction;

  /// Focus node for keyboard focus control.
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fillColor = isDark ? AppColors.darkSurface : AppColors.lightCard;
    final hintColor = isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final iconColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    // אפור שונה מהאפור הרגיל - מעט בהיר יותר במצב dark
    final borderColor = isDark 
        ? AppColors.darkTextTertiary // Color(0xFF6E7177) - אפור בהיר יותר מ-darkBorder
        : AppColors.lightBorder;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      autofocus: autofocus,
      textInputAction: textInputAction,
      style: AppTypography.bodyMedium.copyWith(color: textColor),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText ?? 'חיפוש...',
        hintStyle: AppTypography.bodyMedium.copyWith(color: hintColor),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        prefixIcon: Icon(
          prefixIcon ?? CupertinoIcons.search,
          color: iconColor,
          size: 22,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        suffixIcon: suffixIcon ?? _buildClearButton(context),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget? _buildClearButton(BuildContext context) {
    if (!showClearButton || controller == null) return null;

    return ListenableBuilder(
      listenable: controller!,
      builder: (context, _) {
        if (controller!.text.isEmpty) return const SizedBox.shrink();

        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final iconColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

        return IconButton(
          icon: Icon(CupertinoIcons.xmark, size: 20, color: iconColor),
          onPressed: () {
            controller!.clear();
            onClear?.call();
            onChanged?.call('');
          },
        );
      },
    );
  }
}

/// Compact search bar variant with filter button.
class AppSearchBarWithFilter extends StatelessWidget {
  const AppSearchBarWithFilter({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
    this.filterBadgeCount,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterTap;
  final int? filterBadgeCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: AppSearchBar(
            controller: controller,
            hintText: hintText,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
          ),
        ),
        if (onFilterTap != null) ...[
          AppSpacing.gapMd,
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightCard,
                  borderRadius: AppRadius.borderMedium,
                ),
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.slider_horizontal_3,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  onPressed: onFilterTap,
                ),
              ),
              if (filterBadgeCount != null && filterBadgeCount! > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        filterBadgeCount.toString(),
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

