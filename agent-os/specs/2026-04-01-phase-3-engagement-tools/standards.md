# Phase 3 Standards Applied

All 9 project standards were applied during Phase 3 implementation.

## flutter/hive-model-pattern
@HiveType/@HiveField annotations, generated adapters, registered in main.dart, boxes opened in bootstrap. Manual copyWith methods. TypeIds 9-14 for Phase 3 models.

## flutter/repository-pattern
Concrete repository classes in data/repositories/. Constructor with Box, static _key, get/save/delete. Injected via ProviderScope.overrides at bootstrap.

## flutter/state-management
Riverpod Notifier API. Repository providers throw UnimplementedError, overridden at bootstrap. Notifiers extend Notifier<T?> with build() loading from repo. Screens use ConsumerWidget/ConsumerStatefulWidget.

## flutter/file-organization
Feature-based folders: exercises/, journal/, urge_tracker/, soundscapes/. Each with screen files and widgets/ subfolder. Domain in core/, persistence in data/.

## flutter/screen-structure
Private _build* methods, SafeArea, gradient backgrounds, consistent spacing. Scaffold(backgroundColor: transparent) for screens with TextFields.

## flutter/navigation
Sub-routes as children of Library and Journal shell branches. Full-screen route for urge tracker (outside shell). Route constants in route_names.dart.

## design-system/component-patterns
Used AppButton, GradientButton, AppCard, AppBottomDialog, AppSectionTitle, AppIconButton from design system components. No custom common UI built from scratch.

## design-system/token-usage
All colors via AppColors, spacing via AppSpacing, typography via AppTypography, radius via AppRadius, shadows via AppShadows. No hardcoded values.

## ui/dark-space-theme
Dark-mode-first space/cosmos aesthetic. Deep navy gradient backgrounds (#0A0D2E → #080B22). Dark card styling (AppColors.darkCard). White primary text, darkTextSecondary for secondary.
