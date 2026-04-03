# Phase 3: Engagement Tools — Implementation Plan

## Context

Phase 1-2 are complete (onboarding, streak tracking, pledges, milestones, panic mode, settings, profile). Phase 3 adds 5 engagement features: **Journal**, **Meditation/Exercises**, **Urge Tracker**, **Soundscapes**, and **Library Screen** (content hub). These give users daily coping tools and deepen recovery engagement.

**Key decisions:**
- Lean Phase 3 — no isPremium flags, analytics stubs, or subscription checks (extend later)
- just_audio + bundled audio assets for soundscapes
- No mockups — match existing space/cosmos theme
- All 9 standards injected

**Existing integration points to wire up:**
- `CopingPlaceholder` (panic_mode/widgets/coping_placeholder.dart) — 3 cards with "Coming in Phase 3" lock icons → replace with real navigation
- Home screen QuickActionChips "Meditate" and "Journal" (home_screen.dart:214-222) — no `onTap` handlers → wire to new screens
- Library and Journal tab placeholders already in StatefulShellRoute → replace

---

## Task 1: Save Spec Documentation

Create `agent-os/specs/2026-04-01-phase-3-engagement-tools/` with:
- `plan.md` — This plan
- `shape.md` — Scope summary + decisions (filled after implementation)
- `standards.md` — All 9 standards content
- `references.md` — Key file references used

---

## Task 2: Data Models

Create 6 Hive models (typeIds 9-14). Follow existing pattern: `@HiveType`, `@HiveField`, `copyWith()`, extend `HiveObject`.

| Model | TypeId | Key Fields |
|-------|--------|-----------|
| `JournalEntry` | 9 | id (String), date (DateTime), content (String), mood (int 0-4), prompt (String?), createdAt, updatedAt |
| `JournalData` | 10 | entries (List\<JournalEntry\>) |
| `UrgeEntry` | 11 | id (String), timestamp (DateTime), intensity (int 1-10), trigger (String), note (String?) |
| `UrgeData` | 12 | entries (List\<UrgeEntry\>), totalUrges (int) |
| `ExerciseRecord` | 13 | id (String), completedAt (DateTime), exerciseType (String), durationSeconds (int) |
| `ExerciseData` | 14 | records (List\<ExerciseRecord\>), totalCompleted (int) |

**Mood int mapping:** 0=bad, 1=struggling, 2=okay, 3=good, 4=great (Dart enum for display, int for Hive)
**Trigger categories:** boredom, stress, loneliness, anxiety, habit, social_media, late_night, other (String, not Hive enum — extensible)
**Exercise types:** breathing, urge_surfing, grounding (String, not Hive enum)

**New files:**
- `lib/core/models/journal_entry.dart`
- `lib/core/models/journal_data.dart`
- `lib/core/models/urge_entry.dart`
- `lib/core/models/urge_data.dart`
- `lib/core/models/exercise_record.dart`
- `lib/core/models/exercise_data.dart`

**Modify:** `lib/core/models/models.dart` — add 6 exports

**Then run:** `dart run build_runner build --delete-conflicting-outputs`

---

## Task 3: Repositories

3 new repos following exact pattern from `RelapseRepository` (constructor with Box, static _key, get/save/delete).

**New files:**
- `lib/data/repositories/journal_repository.dart` (box key: `journal_data`)
- `lib/data/repositories/urge_repository.dart` (box key: `urge_data`)
- `lib/data/repositories/exercise_repository.dart` (box key: `exercise_data`)

**Modify:** `lib/data/repositories/repositories.dart` — add 3 exports

**Depends on:** Task 2

---

## Task 4: Providers

3 data providers + 1 ephemeral soundscape provider. Follow existing pattern: repo provider throws, notifier extends `Notifier<T?>`, `build()` loads from repo.

**`lib/core/providers/journal_provider.dart`**
- `journalRepositoryProvider`, `journalNotifierProvider`
- Methods: `addEntry(content, mood, prompt?)`, `updateEntry(id, ...)`, `deleteEntry(id)`

**`lib/core/providers/urge_provider.dart`**
- `urgeRepositoryProvider`, `urgeNotifierProvider`
- Methods: `logUrge(intensity, trigger, note?)`

**`lib/core/providers/exercise_provider.dart`**
- `exerciseRepositoryProvider`, `exerciseNotifierProvider`
- Methods: `recordCompletion(exerciseType, durationSeconds)`

**`lib/core/providers/soundscape_provider.dart`**
- Ephemeral state (no Hive): `isPlaying`, `currentSoundscape`, `volume`, `timerMinutes`
- Wraps audio service lifecycle

**Modify:** `lib/core/providers/providers.dart` — add 4 exports

**Depends on:** Tasks 2, 3

---

## Task 5: Bootstrap (main.dart)

**Modify:** `lib/main.dart`

1. Register 6 new Hive adapters (JournalEntry, JournalData, UrgeEntry, UrgeData, ExerciseRecord, ExerciseData)
2. Open 3 new boxes in `Future.wait()` — indices 7, 8, 9 (SharedPreferences remains at index 6)
3. Create 3 repositories from boxes
4. Add 3 overrides to `ProviderScope` (journal, urge, exercise)

Result: 9 Hive boxes, 21 adapters, 10 provider overrides

**Depends on:** Tasks 2, 3, 4

---

## Task 6: Routing

**Modify:** `lib/routing/route_names.dart` — add route constants:
```
journalEntry = '/journal/entry'
meditate = '/library/meditate'
breathingExercise = '/library/meditate/breathing'
urgeSurfing = '/library/meditate/urge-surfing'
grounding = '/library/meditate/grounding'
soundscapes = '/library/soundscapes'
moodHistory = '/library/mood'
urgeTracker = '/urge'
```

**Modify:** `lib/routing/app_router.dart`
- Add sub-routes as children of Library and Journal shell branches
- Add `/urge` as full-screen route (outside shell, like /panic)

**No dependencies** — route constants and builders can reference forward-declared screens

---

## Task 7: Journal Feature

Replace journal placeholder. ConsumerStatefulWidget (needs TextField/Scaffold).

**New files:**
- `lib/features/journal/journal_screen.dart` — entry list, search, mood filter, FAB to write
- `lib/features/journal/journal_entry_screen.dart` — text editor, mood selector, prompts, save
- `lib/features/journal/journal_history_screen.dart` — calendar grid with mood dots
- `lib/features/journal/widgets/mood_selector.dart` — 5 emoji row (sentiment icons)
- `lib/features/journal/widgets/journal_prompt_chips.dart` — horizontal scroll of prompts
- `lib/features/journal/widgets/journal_entry_card.dart` — entry preview card
- `lib/features/journal/widgets/calendar_view.dart` — month grid with navigation

**Hardcoded prompts:** "What am I grateful for today?", "What triggered me today?", "How did I cope with urges?", "What progress have I noticed?", "What would I tell a friend in my situation?", "What are my goals for tomorrow?"

**Depends on:** Tasks 4, 5, 6

---

## Task 8: Meditation & Exercises

3 guided exercises with animated visuals and completion tracking.

**New files:**
- `lib/features/exercises/meditate_screen.dart` — exercise list/grid with completion counts
- `lib/features/exercises/breathing_exercise_screen.dart` — animated circle (4s inhale, 4s hold, 4s exhale), 5 cycles default, records completion
- `lib/features/exercises/urge_surfing_screen.dart` — timed step prompts (~3min), progress bar, records completion
- `lib/features/exercises/grounding_screen.dart` — 5-4-3-2-1 sensory technique, tap to advance steps, records completion
- `lib/features/exercises/widgets/breathing_circle.dart` — scale animation widget (AnimationController + SingleTickerProviderStateMixin)
- `lib/features/exercises/widgets/exercise_completion_card.dart` — "Well done" overlay after finish
- `lib/features/exercises/widgets/exercise_step_indicator.dart` — reusable step progress

**Depends on:** Tasks 4, 5, 6

---

## Task 9: Urge Tracker

Quick urge logging flow + pattern visualization.

**New files:**
- `lib/features/urge_tracker/urge_tracker_screen.dart` — full-screen flow: intensity slider → trigger selection → optional note → confirm
- `lib/features/urge_tracker/urge_patterns_screen.dart` — time-of-day bars, day-of-week heatmap, top triggers, avg intensity
- `lib/features/urge_tracker/widgets/intensity_slider.dart` — 1-10 slider, green→red gradient
- `lib/features/urge_tracker/widgets/trigger_selector.dart` — grid of selectable category chips with icons
- `lib/features/urge_tracker/widgets/urge_chart.dart` — CustomPainter-based bar/dot visualization (no external chart lib)

**Depends on:** Tasks 4, 5, 6

---

## Task 10: Soundscapes

Audio player with 4 ambient sounds, background playback, timer.

**New dependency:** `just_audio: ^0.9.40` in pubspec.yaml

**Audio assets:** `assets/audio/{campfire,ocean,rain,forest}.mp3` — bundled, loopable ~30-60s clips. Source royalty-free ambient audio.

**Platform config:**
- `ios/Runner/Info.plist` — add `UIBackgroundModes` → `audio`
- `android/app/src/main/AndroidManifest.xml` — add `FOREGROUND_SERVICE` permission

**New files:**
- `lib/core/services/audio_service.dart` — wraps AudioPlayer: play(asset), pause, stop, setVolume, setTimer, dispose, looping mode
- `lib/features/soundscapes/soundscapes_screen.dart` — 4 soundscape cards, volume slider, timer selector
- `lib/features/soundscapes/widgets/soundscape_card.dart` — card with icon (local_fire_department, waves, water_drop, park), playing state animation
- `lib/features/soundscapes/widgets/playback_controls.dart` — play/pause, volume, timer

**Modify:** `pubspec.yaml` — add just_audio dep + `assets: [assets/audio/]`

**Depends on:** Task 6

---

## Task 11: Library Screen

Replace placeholder with content hub. 4 category cards in 2x2 grid.

**Categories:**
| Category | Icon | Color | Navigates to |
|----------|------|-------|-------------|
| Mood | `mood` | AppColors.tertiary | Mood/urge history |
| Meditate | `self_improvement` | AppColors.secondary | Exercise list |
| Lifetree | `park` | AppColors.primary | "Coming in Phase 4" dialog |
| Soundscapes | `music_note` | AppColors.primary variant | Soundscape player |

**New/modified files:**
- `lib/features/library/library_screen.dart` — replace placeholder (ConsumerWidget)
- `lib/features/library/widgets/library_category_card.dart` — square card with icon bubble, title, subtitle
- `lib/features/library/widgets/mood_history_screen.dart` — mood trends from journal + urge patterns summary

**Depends on:** Tasks 7, 8, 9, 10

---

## Task 12: Integration (Home + Panic Mode)

**Modify `lib/features/home/home_screen.dart`:**
- Wire "Meditate" QuickActionChip: `onTap: () => context.push(Routes.meditate)`
- Wire "Journal" QuickActionChip: `onTap: () => context.push(Routes.journalEntry)`
- Replace "More" chip with "Track Urge": `onTap: () => context.push(Routes.urgeTracker)`

**Rewrite `lib/features/panic_mode/widgets/coping_placeholder.dart` → `coping_tools.dart`:**
- Rename `CopingPlaceholder` → `CopingTools`
- "Breathing Exercise" → navigates to breathing exercise screen
- "Journal Entry" → navigates to journal entry screen
- "Guided Meditation" → navigates to meditate screen
- Replace lock icons with chevron_right
- Replace "Coming in Phase 3" with brief descriptions

**Modify `lib/features/panic_mode/panic_mode_screen.dart`:**
- Update import and widget name from CopingPlaceholder to CopingTools

**Depends on:** Tasks 7, 8, 9

---

## Task 13: Final Polish

- Verify all barrel exports complete (models.dart, providers.dart, repositories.dart)
- Run `flutter analyze` — fix any issues
- Update `CLAUDE.md` — current state, project structure, tech stack (add just_audio), key files
- Run `dart run build_runner build --delete-conflicting-outputs` if not already done
- Test cold start, all navigation flows, persistence across restart
- Run `/agent-os:discover-standards` to extract any new patterns worth documenting

**Depends on:** All tasks

---

## Dependency Graph (Execution Order)

```
Parallel:  Task 1 (Spec) + Task 2 (Models) + Task 6 (Routing)
Then:      Task 3 (Repos) → Task 4 (Providers) → Task 5 (Bootstrap)
Parallel:  Task 7 (Journal) + Task 8 (Exercises) + Task 9 (Urge) + Task 10 (Soundscapes)
Then:      Task 11 (Library) → Task 12 (Integration) → Task 13 (Polish)
```

---

## File Inventory

**New files (~36):**
- 4 spec docs
- 6 models + generated .g.dart files
- 3 repositories
- 4 providers
- 1 service (audio)
- 7 journal feature files
- 7 exercise feature files
- 5 urge tracker feature files
- 3 soundscape feature files
- 3 library feature files
- 4 audio assets

**Modified files (~12):**
- `lib/main.dart` — adapters, boxes, repos, overrides
- `lib/core/models/models.dart` — barrel
- `lib/core/providers/providers.dart` — barrel
- `lib/data/repositories/repositories.dart` — barrel
- `lib/routing/route_names.dart` — new constants
- `lib/routing/app_router.dart` — sub-routes
- `lib/features/library/library_screen.dart` — replace placeholder
- `lib/features/journal/journal_screen.dart` — replace placeholder
- `lib/features/home/home_screen.dart` — wire quick actions
- `lib/features/panic_mode/widgets/coping_placeholder.dart` → rewrite as coping_tools.dart
- `lib/features/panic_mode/panic_mode_screen.dart` — update widget reference
- `pubspec.yaml` — just_audio + assets
- `ios/Runner/Info.plist` — background audio
- `android/app/src/main/AndroidManifest.xml` — foreground service
- `CLAUDE.md` — update docs

---

## Verification (End-to-End)

1. **Cold start** — app launches, 9 Hive boxes open, no crashes
2. **Journal flow** — Journal tab → write entry → select mood → pick prompt → save → see in list → search → calendar view
3. **Exercise flow** — "Meditate" chip → exercise list → breathing exercise → complete → count increments
4. **Urge flow** — "Track Urge" chip → intensity → trigger → note → confirm → see patterns
5. **Soundscape flow** — Library → Soundscapes → play Rain → volume → timer → background app → audio continues → timer stops
6. **Library hub** — 4 cards visible → Mood/Meditate/Soundscapes navigate → Lifetree shows placeholder
7. **Panic Mode** — "I'm thinking of relapsing" → coping tools → breathing exercise works → journal entry works
8. **Persistence** — kill app → reopen → journal entries + urge data + exercise records persist
9. **Theme** — all screens use gradient background, design tokens, dark card styling
