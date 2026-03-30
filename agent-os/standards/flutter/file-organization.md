# File Organization

## Rule

Follow the feature-based folder structure. Each feature gets its own folder with a screen file and a `widgets/` subfolder for feature-specific widgets.

## Structure

```
lib/
├── design_system/          # Shared design system (tokens, components, themes)
│   ├── components/         # Reusable components
│   ├── tokens/             # Color, spacing, typography, radius, shadow tokens
│   ├── theme/              # ThemeData configuration
│   └── design_system.dart  # Barrel export
├── features/               # Feature modules
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/        # Home-specific widgets
│   ├── quiz/
│   │   ├── quiz_screen.dart
│   │   └── widgets/
│   └── ...
├── shared/                 # Cross-feature shared code
│   └── widgets/            # Shared widgets (star_field, etc.)
└── main.dart
```

## Naming

- Screens: `feature_screen.dart` → `FeatureScreen` class
- Widgets: `descriptive_name.dart` → `DescriptiveName` class
- Barrel exports: `components.dart`, `tokens.dart`, `theme.dart`
