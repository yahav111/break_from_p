# Dark Space Theme

## Rule

All new screens must follow the dark space/cosmos aesthetic. The app is dark-mode-first with a deep navy color palette.

## Background Gradients

Standard screen backgrounds use deep navy gradients:
- Primary: `#0A0D2E` → `#080B22` (top to bottom)
- Paywall variant: `#1A0A40` → `#0A0D2E` (deeper purple at top)
- Flat dark: `AppColors.darkBackground` (#0A0D2E)

## Star Field

Key screens (onboarding, quiz, paywall) include the `StarField` widget as a background layer:
```dart
const StarField(density: 60) // 60-80 density
```

Home screen uses gradient only (no star field) to feel more grounded/daily-use.

## Card Styling

- Cards use `AppColors.darkCard` (#1A1F52) or semi-transparent backgrounds
- Borders: `AppColors.darkBorderSubtle` (#1E2260), 0.5-1px width
- Rounded corners: use `AppRadius.*` tokens

## Text on Dark

- Primary text: `Colors.white`
- Secondary text: `AppColors.darkTextSecondary` (#B0B8D4)
- Use `.copyWith(color: ...)` on typography tokens
