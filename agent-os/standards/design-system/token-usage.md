# Token Usage

## Rule

Always use design system tokens for colors, spacing, typography, radius, and shadows. Never hardcode raw values.

## Color Tokens

- Use `AppColors.*` for all colors — semantic naming maps to dark/light themes
- Background layers: `darkBackground` → `darkSurface` → `darkCard` → `darkElevated`
- Text hierarchy: `darkTextPrimary` → `darkTextSecondary` → `darkTextTertiary`
- Brand: `primary` (purple), `secondary` (green), `tertiary` (orange)
- Icon bubbles: `iconBubblePurple`, `iconBubbleGreen`, etc.

## Spacing Tokens

- Use `AppSpacing.*` constants: `xs(4)`, `sm(8)`, `md(12)`, `lg(16)`, `xl(20)`, `xxl(24)`, `xxxl(32)`
- Screen horizontal padding: `AppSpacing.lg` or `AppSpacing.xxl`
- Use `AppSpacing.allLg`, `AppSpacing.horizontalXl`, etc. for EdgeInsets shortcuts

## Typography

- Use `AppTypography.*` styles: `headlineLarge`, `titleMedium`, `bodyLarge`, `bodyMedium`, `caption`, `button`
- Customize with `.copyWith()` — never create `TextStyle` from scratch

## Radius

- Use `AppRadius.*` — `borderPill` for buttons, standard radius for cards

## Shadows

- Use `AppShadows.*` — `gradientGlow` for gradient buttons
