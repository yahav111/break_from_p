# File Organization

## Rule

Follow the feature-based folder structure. Each feature gets its own folder with a screen file and a `widgets/` subfolder for feature-specific widgets. Domain logic lives in `core/`, persistence in `data/`, navigation in `routing/`.

## Structure

```
lib/
├── main.dart                    # Async bootstrap (Hive, SharedPrefs, ProviderScope)
├── app.dart                     # QuittrApp (ConsumerWidget, MaterialApp.router)
├── core/                        # Pure Dart domain layer (no Flutter imports)
│   ├── models/                  # Data classes (@HiveType for persisted, plain for ephemeral)
│   ├── providers/               # Riverpod Notifiers (cross-feature state)
│   └── services/                # Business logic utilities (pure functions)
├── data/                        # Persistence layer (depends on Hive, SharedPreferences)
│   └── repositories/            # Storage abstraction (one per model)
├── routing/                     # go_router config and route constants
│   ├── app_router.dart
│   └── route_names.dart
├── design_system/               # Shared design system (tokens, components, themes)
│   ├── components/
│   ├── tokens/
│   ├── theme/
│   └── design_system.dart       # Barrel export
├── features/                    # Feature modules
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   ├── shell/                   # MainShell (bottom nav scaffold)
│   │   └── main_shell.dart
│   ├── quiz/
│   │   ├── quiz_screen.dart
│   │   └── widgets/
│   └── ...
├── shared/                      # Cross-feature shared code
│   └── widgets/
└── test/                        # Mirrors lib/ structure
    ├── core/
    │   ├── models/
    │   ├── providers/
    │   └── services/
    └── ...
```

## Naming

- Screens: `feature_screen.dart` → `FeatureScreen` class
- Widgets: `descriptive_name.dart` → `DescriptiveName` class
- Barrel exports: `components.dart`, `tokens.dart`, `models.dart`, `providers.dart`, `repositories.dart`
- Models: `model_name.dart` → `ModelName` class
- Providers: `model_name_provider.dart` → `modelNameNotifierProvider`
- Repositories: `model_name_repository.dart` → `ModelNameRepository` class
