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
