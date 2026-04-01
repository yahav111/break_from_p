# Quittr — Tech Stack

## Frontend

- **Framework:** Flutter (Dart)
- **Platforms:** iOS, Android (primary), Web, macOS, Windows, Linux (secondary)
- **Design System:** Custom design system (`lib/design_system/`) with tokens, components, and themes
- **Theme:** Dark mode primary, space/cosmos aesthetic with star field backgrounds

## State Management

- **flutter_riverpod** ^2.6.1 — Notifier API (not legacy StateNotifier)
- Providers in `lib/core/providers/`, repository providers overridden at bootstrap via `ProviderScope.overrides`
- Screens use `ConsumerWidget` / `ConsumerStatefulWidget`

## Routing

- **go_router** ^14.8.1 — Declarative routing with redirect logic
- `StatefulShellRoute.indexedStack` for bottom navigation (preserves tab state)
- Full-screen routes outside shell: `/settings`, `/panic`
- Route definitions in `lib/routing/`

## Local Storage

- **shared_preferences** ^2.3.4 — Simple key-value data (AppState flags, milestone tracking)
- **hive** ^2.2.3 + **hive_flutter** ^1.1.0 — Structured data (UserProfile, StreakData, PledgeData, RelapseData, ReasonsData, NotificationPreferences)
- **hive_generator** ^2.0.1 + **build_runner** ^2.4.13 — Code generation for Hive TypeAdapters
- Repository pattern in `lib/data/repositories/`

## Permissions & Device

- **permission_handler** ^11.3.1 — Notification permission requests (iOS/Android)
- **camera** ^0.11.0+2 — Front camera for Panic Mode mirror feature

## Notifications

- **flutter_local_notifications** ^18.0.1 — Local notification scheduling (reminders, milestones)

## Backend

- TBD (likely Firebase or Supabase for auth and database)

## Payments

- TBD — RevenueCat for in-app subscriptions (Phase 5)

## Analytics

- TBD — Firebase Analytics or Mixpanel (Phase 5)

## Other

- **Linting:** flutter_lints
- **SDK:** Dart ^3.10.0
- **Icons:** Material Icons + Cupertino Icons
- **path_provider** ^2.1.5 — Required by hive_flutter for storage paths
