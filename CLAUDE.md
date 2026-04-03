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

1. **Project Foundation** ✅ — Navigation (go_router), state management (Riverpod), local storage (Hive), 7-step quiz, basic streak
2. **Core Features** ✅ — Real-time streak, pledges, brain rewire milestones, notifications, settings, panic mode (camera), relapses counter, reasons for quitting
3. **Engagement Tools** ✅ — Journal (entries, mood, prompts, calendar), meditation/exercises (breathing, urge surfing, grounding), urge tracker (intensity, triggers, patterns), soundscapes (4 ambient sounds, background audio), library screen (content hub)
4. **Gamification & Progression** ← NEXT — Character evolution, milestones, milestone path, stats dashboard, lifetree
5. **Monetization & Growth** — IAP (RevenueCat), personalized recovery plan, analytics
6. **Polish & Launch** — Performance, crash reporting, App Store/Play Store submission, testing, privacy compliance

## Tech Stack

- **Framework:** Flutter (Dart), SDK ^3.10.0
- **State Management:** Riverpod (Notifier API, `ConsumerWidget` / `ConsumerStatefulWidget`)
- **Local Storage:** Hive + hive_generator (UserProfile, StreakData, PledgeData, RelapseData, ReasonsData, NotificationPreferences, JournalData, JournalEntry, UrgeData, UrgeEntry, ExerciseData, ExerciseRecord) + shared_preferences (AppState)
- **Routing:** go_router with StatefulShellRoute.indexedStack for bottom nav, full-screen routes for Settings/Panic/UrgeTracker, sub-routes for Library and Journal
- **Permissions:** permission_handler (notifications)
- **Camera:** camera package (Panic Mode front camera mirror)
- **Audio:** just_audio (soundscapes playback with background audio support)
- **Notifications:** flutter_local_notifications (scheduling)
- **Platforms:** iOS, Android (primary), Web (secondary)
- **Language:** English only

## Code Conventions

- **Design tokens:** Always use `AppColors`, `AppSpacing`, `AppTypography`, `AppRadius`, `AppShadows` — never hardcode values
- **Components:** Use existing design system components (`AppButton`, `AppCard`, `GradientButton`, `AppBottomDialog`, etc.) — never build custom common UI from scratch
- **File structure:** Feature-based folders with `screen.dart`, `widgets/` subfolder, and barrel exports
- **Screen pattern:** Private `_build*` methods, `SafeArea`, gradient backgrounds, consistent spacing. Screens needing TextField must wrap in `Scaffold(backgroundColor: Colors.transparent)`
- **Theme:** Dark-mode-first space/cosmos aesthetic — deep navy gradients, `StarField` backgrounds, dark card styling
- **State:** Riverpod `Notifier` classes in `lib/core/providers/`. Repository providers overridden at bootstrap in `ProviderScope.overrides`
- **Storage:** Repository pattern — concrete classes in `lib/data/repositories/`, injected via Riverpod provider overrides
- **Navigation:** `context.go()` for flow transitions, `context.push()` for full-screen overlays (settings, panic). Onboarding flow uses top-level routes, main app uses `StatefulShellRoute`
- **Models:** Hive types use `@HiveType` / `@HiveField` annotations + code generation. Manual `copyWith` methods (no freezed)

## Current State

Phases 1-3 complete. The app has onboarding, real-time streak tracking (live d/h/m/s), daily pledges, milestone celebrations (7/14/30/60/90 days with science messages), panic mode with front camera and coping tools, notifications, settings, relapse tracking, reasons for quitting, profile screen, journal with mood tracking and prompts, 3 meditation exercises (breathing, urge surfing, grounding), urge tracker with pattern visualization, soundscapes with background audio, and a library content hub. Phase 4 (Gamification & Progression) is next.

## Project Structure

```
lib/
├── main.dart                    # Async bootstrap (9 Hive boxes, SharedPrefs, 10 repo overrides)
├── app.dart                     # QuittrApp (ConsumerWidget, MaterialApp.router)
├── core/
│   ├── models/                  # UserProfile, StreakData, StreakRecord, AppState, QuizQuestion,
│   │                            # PledgeData, RelapseData, RelapseEntry, ReasonsData,
│   │                            # MilestoneInfo, NotificationPreferences,
│   │                            # JournalEntry, JournalData, UrgeEntry, UrgeData,
│   │                            # ExerciseRecord, ExerciseData
│   ├── providers/               # AppState, UserProfile, Streak, LiveStreak, Quiz,
│   │                            # Pledge, Relapse, Reasons, NotificationPreferences,
│   │                            # Journal, Urge, Exercise, Soundscape
│   └── services/                # StreakEngine (with milestones), NotificationService, AudioService
├── data/
│   └── repositories/            # AppState, UserProfile, Streak, Pledge, Relapse,
│                                # Reasons, NotificationPreferences, Journal, Urge, Exercise
├── routing/                     # GoRouter config (/settings, /panic, /urge, shell routes + sub-routes)
├── design_system/               # Tokens, components, theme
├── features/
│   ├── welcome/                 # Welcome screen
│   ├── quiz/                    # 7-step quiz flow
│   ├── onboarding/              # Notification permission
│   ├── paywall/                 # Subscription plans
│   ├── home/                    # Dashboard: streak card, pledge card, reasons, stats, milestones, quick actions
│   │   └── widgets/             # StreakCard, PledgeCard, ReasonsSection, MilestoneCelebrationDialog, QuickActionChip, etc.
│   ├── settings/                # Settings screen (profile, notifications, quit date)
│   ├── panic_mode/              # Panic mode (QUITTR header, camera card, coping tools with real navigation)
│   ├── shell/                   # MainShell (bottom nav)
│   ├── library/                 # Content hub: Mood, Meditate, Lifetree (Phase 4), Soundscapes
│   │   └── widgets/             # LibraryCategoryCard, MoodHistoryScreen
│   ├── journal/                 # Journal entries, mood tracking, calendar history, prompts
│   │   └── widgets/             # MoodSelector, JournalPromptChips, JournalEntryCard, CalendarView
│   ├── exercises/               # Breathing exercise, urge surfing, grounding (5-4-3-2-1)
│   │   └── widgets/             # BreathingCircle, ExerciseCompletionCard, ExerciseStepIndicator
│   ├── urge_tracker/            # Urge logging (intensity, triggers), pattern visualization
│   │   └── widgets/             # IntensitySlider, TriggerSelector, UrgeChart
│   ├── soundscapes/             # Ambient sound player (campfire, ocean, rain, forest)
│   │   └── widgets/             # SoundscapeCard, PlaybackControls
│   └── profile/                 # Profile with avatar, stats, settings nav
└── shared/widgets/              # StarField
```

## Key Files

- `lib/main.dart` — App bootstrap with 9 Hive boxes + SharedPreferences init, 10 repo overrides
- `lib/routing/app_router.dart` — GoRouter with redirect logic, shell routes, sub-routes for library/journal
- `lib/core/providers/providers.dart` — All Riverpod providers (barrel)
- `lib/core/models/models.dart` — All data models (barrel)
- `lib/core/services/streak_engine.dart` — Pure streak calculations + milestone data
- `lib/core/services/audio_service.dart` — just_audio wrapper for soundscape playback
- `lib/data/repositories/repositories.dart` — All repositories (barrel)
- `lib/design_system/design_system.dart` — Design system barrel import
