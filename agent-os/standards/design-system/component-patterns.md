# Component Patterns

## Rule

Use existing design system components from `lib/design_system/components/`. Never build custom buttons, cards, or common UI elements from scratch.

## Available Components

- `AppButton` — Primary, secondary, ghost, danger, gradient variants with small/medium/large sizes
- `GradientButton` — Purple→pink gradient CTA button with glow shadow
- `AppCard` — Elevated card with consistent styling
- `AppIconButton` — Circular icon buttons (filled, ghost)
- `AppScaffold` — Screen scaffold with consistent padding
- `AppBottomDialog` — Bottom sheet dialogs
- `AppModalSheet` — Modal bottom sheets
- `AppLoading` — Loading indicators
- `AppSearchBar` — Search input field
- `AppListTileCard` — List items with card styling
- `AppSectionTitle` — Section heading text
- `AppStatsCard` — Stats display card
- `AppFadeInImage` — Image with fade-in animation
- `AppIconCircle` — Circular icon with background bubble
- `AppBottomNav` — Bottom navigation bar

## Import Pattern

```dart
import '../../design_system/design_system.dart'; // Barrel import
```

Single barrel import gives access to all tokens and components.

## Screen Background Pattern

Screens use gradient Container + StarField stack:

```dart
Stack(
  fit: StackFit.expand,
  children: [
    Container(decoration: BoxDecoration(gradient: ...)),
    const StarField(density: 60),
    _buildContent(),
  ],
);
```
