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
4. **Gamification & Progression** ✅ — Character evolution (7 stages, CustomPainter), achievement badges (18 achievements), enhanced milestone path (tappable orbs), statistics dashboard (fl_chart), lifetree (constellation skill tree with bonus content)
5. **Monetization & Growth** ← NEXT — IAP (RevenueCat), personalized recovery plan, analytics
6. **Polish & Launch** — Performance, crash reporting, App Store/Play Store submission, testing, privacy compliance

## Tech Stack

- **Framework:** Flutter (Dart), SDK ^3.10.0
- **State Management:** Riverpod (Notifier API, `ConsumerWidget` / `ConsumerStatefulWidget`)
- **Local Storage:** Hive + hive_generator (UserProfile, StreakData, PledgeData, RelapseData, ReasonsData, NotificationPreferences, JournalData, JournalEntry, UrgeData, UrgeEntry, ExerciseData, ExerciseRecord, AchievementEntry, AchievementData, LifetreeData) + shared_preferences (AppState)
- **Routing:** go_router with StatefulShellRoute.indexedStack for bottom nav, full-screen routes for Settings/Panic/UrgeTracker/Stats/Badges/Lifetree, sub-routes for Library and Journal
- **Permissions:** permission_handler (notifications)
- **Camera:** camera package (Panic Mode front camera mirror)
- **Audio:** just_audio (soundscapes playback with background audio support)
- **Charts:** fl_chart (statistics dashboard: bar, line, pie charts)
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
- **Models:** Hive types use `@HiveType` / `@HiveField` annotations + code generation (typeIds 0-17). Manual `copyWith` methods (no freezed)
- **Services:** Pure logic in `abstract final class` with static methods (CharacterEngine, AchievementEngine, StatsEngine, LifetreeEngine, JournalPromptsEngine)
- **CustomPainter:** Used for character evolution visuals (7 stages) and Lifetree constellation tree. Painters accept `animationValue` (0-1) for animation.

## Current State

Phases 1-4 complete. The app has onboarding, real-time streak tracking (live d/h/m/s), daily pledges, milestone celebrations (7/14/30/60/90 days with science messages), panic mode with front camera and coping tools, notifications, settings, relapse tracking, reasons for quitting, profile screen, journal with mood tracking and prompts (including Lifetree-unlocked bonus prompts), 4 meditation exercises (breathing with parameterized patterns, urge surfing, grounding, body scan), urge tracker with pattern visualization, soundscapes with background audio, library content hub, character evolution system (7 stages from Sprout to Cosmos with animated transitions), 18 achievement badges, enhanced milestone path with tappable orbs, statistics dashboard with streak history/mood trend/exercise breakdown charts, and Lifetree constellation skill tree (9 nodes unlocking breathing patterns, journal prompts, body scan, and coming-soon soundscapes). Phase 5 (Monetization & Growth) is next.

## Project Structure

```
lib/
├── main.dart                    # Async bootstrap (12 Hive boxes, SharedPrefs, 12 repo overrides)
├── app.dart                     # QuittrApp (ConsumerWidget, MaterialApp.router)
├── core/
│   ├── models/                  # UserProfile, StreakData, StreakRecord, AppState, QuizQuestion,
│   │                            # PledgeData, RelapseData, RelapseEntry, ReasonsData,
│   │                            # MilestoneInfo, NotificationPreferences,
│   │                            # JournalEntry, JournalData, UrgeEntry, UrgeData,
│   │                            # ExerciseRecord, ExerciseData,
│   │                            # AchievementEntry, AchievementData, LifetreeData,
│   │                            # CharacterStage, BreathingParams
│   ├── providers/               # AppState, UserProfile, Streak, LiveStreak, Quiz,
│   │                            # Pledge, Relapse, Reasons, NotificationPreferences,
│   │                            # Journal, Urge, Exercise, Soundscape,
│   │                            # Achievement, Lifetree
│   └── services/                # StreakEngine, NotificationService, AudioService,
│                                # CharacterEngine, AchievementEngine, StatsEngine,
│                                # LifetreeEngine, JournalPromptsEngine
├── data/
│   └── repositories/            # AppState, UserProfile, Streak, Pledge, Relapse,
│                                # Reasons, NotificationPreferences, Journal, Urge, Exercise,
│                                # Achievement, Lifetree
├── routing/                     # GoRouter config (shell routes + full-screen routes)
├── design_system/               # Tokens, components, theme
├── features/
│   ├── welcome/                 # Welcome screen
│   ├── quiz/                    # 7-step quiz flow
│   ├── onboarding/              # Notification permission
│   ├── paywall/                 # Subscription plans
│   ├── home/                    # Dashboard: streak card with character, pledge card, reasons, stats, milestones, quick actions
│   │   └── widgets/             # StreakCard, CharacterDisplay, DayOrbsRow, PledgeCard, ReasonsSection, etc.
│   │       └── characters/      # 7 CustomPainter files (SproutPainter through CosmosPainter) + factory
│   ├── settings/                # Settings screen (profile, notifications, quit date)
│   ├── panic_mode/              # Panic mode (QUITTR header, camera card, coping tools)
│   ├── shell/                   # MainShell (bottom nav)
│   ├── library/                 # Content hub: Mood, Meditate, Lifetree, Soundscapes
│   │   └── widgets/             # LibraryCategoryCard, MoodHistoryScreen
│   ├── journal/                 # Journal entries, mood tracking, calendar history, prompts
│   │   └── widgets/             # MoodSelector, JournalPromptChips (Lifetree-integrated), JournalEntryCard, CalendarView
│   ├── exercises/               # Breathing (parameterized), urge surfing, grounding, body scan
│   │   └── widgets/             # BreathingCircle, ExerciseCompletionCard, ExerciseStepIndicator
│   ├── urge_tracker/            # Urge logging (intensity, triggers), pattern visualization
│   │   └── widgets/             # IntensitySlider, TriggerSelector, UrgeChart
│   ├── soundscapes/             # Ambient sound player (campfire, ocean, rain, forest)
│   │   └── widgets/             # SoundscapeCard, PlaybackControls
│   ├── achievements/            # Badge collection screen with 18 achievements
│   │   └── widgets/             # BadgeTile, AchievementToast
│   ├── statistics/              # Statistics dashboard with fl_chart charts
│   │   └── widgets/             # StreakHistoryChart, MoodTrendChart, ExercisePieChart
│   ├── lifetree/                # Constellation skill tree (9 nodes, bonus content)
│   │   └── widgets/             # LifetreeCanvas, LifetreeNodeDialog
│   └── profile/                 # Profile with avatar, stats, achievements/statistics nav
└── shared/widgets/              # StarField
```

## Key Files

- `lib/main.dart` — App bootstrap with 12 Hive boxes + SharedPreferences init, 12 repo overrides
- `lib/routing/app_router.dart` — GoRouter with redirect logic, shell routes, all feature routes
- `lib/core/providers/providers.dart` — All Riverpod providers (barrel)
- `lib/core/models/models.dart` — All data models (barrel)
- `lib/core/services/streak_engine.dart` — Pure streak calculations + milestone data
- `lib/core/services/character_engine.dart` — Character stage mapping (7 stages from streak days)
- `lib/core/services/achievement_engine.dart` — 18 achievement definitions + condition checking
- `lib/core/services/stats_engine.dart` — Statistics computation from all data sources
- `lib/core/services/lifetree_engine.dart` — 9 Lifetree node definitions + unlock conditions
- `lib/core/services/journal_prompts_engine.dart` — Default + Lifetree-unlockable journal prompts
- `lib/core/services/audio_service.dart` — just_audio wrapper for soundscape playback
- `lib/data/repositories/repositories.dart` — All repositories (barrel)
- `lib/design_system/design_system.dart` — Design system barrel import
