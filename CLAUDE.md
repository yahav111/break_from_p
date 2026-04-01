# Quittr

A Flutter mobile app helping people quit pornography addiction through streak tracking, daily pledges, panic mode intervention, gamification, and a space/cosmos dark theme.

## Agent OS

This project uses an **agent-os** system for product documentation, standards, and phased implementation. Always read it before making changes.

- `agent-os/product/` — Mission, roadmap, tech stack
- `agent-os/initialization/context/` — Project context and product vision
- `agent-os/initialization/phases/` — Phase 1–6 detailed specs
- `agent-os/initialization/Implementation-Prompts.md` — Copy-paste prompts for each phase
- `agent-os/standards/` — Coding and design standards (indexed in `index.yml`)
- `agent-os/specs/` — Implementation specs created by `/agent-os:shape-spec`

### Agent OS Commands

- `/agent-os:shape-spec` — Plan and structure work for a phase (use in plan mode)
- `/agent-os:inject-standards` — Inject relevant standards into current context
- `/agent-os:discover-standards` — Extract new standards from code you just wrote
- `/agent-os:index-standards` — Rebuild the standards index
- `/agent-os:plan-product` — Establish or update product documentation

## Roadmap (6 Phases)

1. **Project Foundation** — Navigation, state management (Riverpod), local storage (Hive), basic streak
2. **Core Features** — Streak engine, pledges, brain rewire, notifications, settings, panic mode, relapses counter, reasons for quitting
3. **Engagement Tools** — Journal, meditation/exercises, urge tracker, soundscapes, library screen
4. **Gamification & Progression** — Character evolution, milestones, milestone path, stats dashboard, lifetree
5. **Monetization & Growth** — IAP (RevenueCat), personalized recovery plan, analytics
6. **Polish & Launch** — Performance, crash reporting, App Store/Play Store submission, testing, privacy compliance

## Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Riverpod
- **Local Storage:** Hive + shared_preferences
- **Routing:** go_router
- **Platforms:** iOS, Android (primary), Web (secondary)
- **Language:** English only

## Code Conventions

- **Design tokens:** Always use `AppColors`, `AppSpacing`, `AppTypography`, `AppRadius`, `AppShadows` — never hardcode values
- **Components:** Use existing design system components (`AppButton`, `AppCard`, `GradientButton`, etc.) — never build custom common UI from scratch
- **File structure:** Feature-based folders with `screen.dart`, `widgets/` subfolder, and barrel exports
- **Screen pattern:** Private `_build*` methods, `SafeArea`, gradient backgrounds, consistent spacing
- **Theme:** Dark-mode-first space/cosmos aesthetic — deep navy gradients, `StarField` backgrounds, dark card styling

## Current State

Design system and static UI screens are built. No business logic, navigation, state management, or persistence yet. Phase 1 has not started.

## Key Design Files

- `lib/design_system/` — Tokens and reusable components
- `lib/features/` — Feature screens (home, welcome, quiz, onboarding, paywall, showcase)
- `lib/shared/widgets/` — Star field background
