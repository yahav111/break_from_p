# Phase 4 Standards

## flutter/state-management

# State Management

## Rule

Use Riverpod's modern Notifier API for all state management. Providers live in `lib/core/providers/`. Screens consume state via `ConsumerWidget` or `ConsumerStatefulWidget`.

## Provider Pattern

```dart
// Repository provider — overridden at bootstrap
final myRepositoryProvider = Provider<MyRepository>((ref) {
  throw UnimplementedError('must be overridden');
});

// State notifier provider
final myNotifierProvider =
    NotifierProvider<MyNotifier, MyState>(MyNotifier.new);

class MyNotifier extends Notifier<MyState> {
  @override
  MyState build() {
    final repo = ref.read(myRepositoryProvider);
    return repo.load();
  }

  Future<void> update(MyState newState) async {
    final repo = ref.read(myRepositoryProvider);
    await repo.save(newState);
    state = newState;
  }
}
```

## Bootstrap Override Pattern

Repositories are created in `main()` after Hive/SharedPreferences init, then injected via `ProviderScope.overrides`:

```dart
ProviderScope(
  overrides: [
    myRepositoryProvider.overrideWithValue(repo),
  ],
  child: const QuittrApp(),
)
```

## Screen Consumption

- Read-only display: `ref.watch(provider)` in `build()`
- Trigger actions: `ref.read(provider.notifier).method()` in callbacks
- Stateless screens → `ConsumerWidget`
- Screens with local UI state (e.g., text controllers) → `ConsumerStatefulWidget`

## Conventions

- One provider per file in `lib/core/providers/`
- Barrel export via `providers.dart`
- Use `Notifier` (not legacy `StateNotifier`)
- Nullable state (`MyType?`) when data may not exist yet (e.g., no user profile before quiz)

## flutter/repository-pattern

# Repository Pattern

## Rule

All persistence goes through repository classes in `lib/data/repositories/`. Repositories are concrete classes (no abstract interfaces). They are injected into Riverpod providers via `ProviderScope.overrides` at bootstrap.

## Structure

```
lib/data/
├── repositories/
│   ├── app_state_repository.dart       # SharedPreferences-backed
│   ├── user_profile_repository.dart    # Hive-backed
│   ├── streak_repository.dart          # Hive-backed
│   └── repositories.dart               # Barrel export
└── data.dart                           # Barrel export
```

## Hive Repository Pattern

```dart
class MyRepository {
  MyRepository(this._box);
  final Box<MyModel> _box;
  static const _key = 'my_model';

  MyModel? get() => _box.get(_key);
  Future<void> save(MyModel model) => _box.put(_key, model);
  Future<void> delete() => _box.delete(_key);
}
```

## SharedPreferences Repository Pattern

```dart
class AppStateRepository {
  AppStateRepository(this._prefs);
  final SharedPreferences _prefs;

  AppState load() => AppState(
    myFlag: _prefs.getBool('my_flag') ?? false,
  );

  Future<void> save(AppState state) async {
    await _prefs.setBool('my_flag', state.myFlag);
  }
}
```

## Hive Model Convention

- Use `@HiveType(typeId: N)` and `@HiveField(N)` annotations
- Run `dart run build_runner build --delete-conflicting-outputs` to generate adapters
- Register adapters in `main()` before opening boxes
- Models extend `HiveObject` and have manual `copyWith` methods

## flutter/screen-structure

# Screen Structure

## Rule

Follow the established screen layout pattern: private `_build*` methods for each section, SafeArea wrapping, and consistent spacing.

## Pattern

```dart
class FeatureScreen extends StatelessWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0D2E), Color(0xFF080B22)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              _buildHeader(),
              // ... sections
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() { ... }
  Widget _buildContent() { ... }
}
```

## Conventions

- Each visual section is a private `_build*` method
- `SafeArea` wraps content on every screen
- `SingleChildScrollView` for scrollable content
- Horizontal padding: `AppSpacing.lg` (16) or `AppSpacing.xxl` (24)
- Section spacing: `SizedBox(height: AppSpacing.xxl)` between major sections
- Back button: 44x44 circle with `overlayWhiteSubtle` background

## flutter/file-organization

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

## flutter/navigation

# Navigation

## Rule

Use go_router for all navigation. Router config lives in `lib/routing/app_router.dart`. Route path constants live in `lib/routing/route_names.dart`.

## Router Structure

Two zones:

1. **Onboarding flow** — Top-level routes, no bottom nav shell. Fade transitions.
2. **Main app** — `StatefulShellRoute.indexedStack` wrapping a `MainShell` scaffold with `AppBottomNav`.

## Redirect Logic

A single top-level `redirect` callback controls access:
- `onboardingCompleted == false` + not on onboarding route → redirect to `/welcome`
- `onboardingCompleted == true` + on onboarding route → redirect to `/`

## Navigation Methods

- `context.go('/path')` — Replace current route (use for flow transitions)
- `context.push('/path')` — Push onto stack (use for modals/detail screens)
- `context.pop()` — Go back

## Bottom Navigation

`MainShell` uses `AppBottomNav` from the design system. Tab switching:
```dart
navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex)
```

## Route Constants

```dart
abstract final class Routes {
  static const welcome = '/welcome';
  static const quiz = '/quiz';
  static const home = '/';
  // ...
}
```

## Page Transitions

Onboarding screens use `CustomTransitionPage` with fade. Main app tabs switch instantly (no animation).

## design-system/component-patterns

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

## design-system/token-usage

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

## ui/dark-space-theme

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
