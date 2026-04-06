# Phase 4: Gamification & Progression — Implementation Plan

## Context

Phases 1-3 are complete (onboarding, streak tracking, pledges, milestones, panic mode, notifications, settings, journal, meditation exercises, urge tracker, soundscapes, library). Phase 4 adds gamification and progression systems to reward recovery progress and sustain long-term motivation: **character evolution**, **achievement badges**, **enhanced milestone path**, **statistics dashboard**, and **lifetree** (skill tree unlocking bonus content).

**Key decisions:**
- **Character art**: Programmatic CustomPainter creatures (no external assets) — swappable later
- **Charts**: `fl_chart` library for stats dashboard
- **Lifetree**: Unlocks NEW bonus content (existing features stay fully accessible)
- **Milestone Path**: Enhance existing Day Orbs carousel (add character art + tappable details, not a separate screen)
- **All 8 standards injected**
- **No mockups** — match existing space/cosmos aesthetic

---

## Task 1: Save Spec Documentation

Create `agent-os/specs/2026-04-06-phase-4-gamification-progression/` with:
- `plan.md` — This plan
- `shape.md` — Scope + decisions
- `standards.md` — All 8 standards content
- `references.md` — Key code references

---

## Task 2: New Dependency + Data Models

### 2A: Add fl_chart

**Modify:** `pubspec.yaml` — add `fl_chart: ^0.69.0`

### 2B: Hive models (typeIds 15-17)

| Model | TypeId | File | Fields |
|-------|--------|------|--------|
| `AchievementEntry` | 15 | `lib/core/models/achievement_entry.dart` | id (String), unlockedAt (DateTime) |
| `AchievementData` | 16 | `lib/core/models/achievement_data.dart` | entries (List\<AchievementEntry\>) |
| `LifetreeData` | 17 | `lib/core/models/lifetree_data.dart` | unlockedNodeIds (List\<String\>) |

### 2C: Non-Hive models

| Model | File | Purpose |
|-------|------|---------|
| `CharacterStage` enum | `lib/core/models/character_stage.dart` | 7 stages: sprout/ember/flame/blaze/phoenix/nova/cosmos |
| `BreathingParams` | `lib/core/models/breathing_params.dart` | inhale/hold/exhale/cycles/label for parameterized breathing |

### 2D: AppState extension (SharedPreferences)

**Modify:** `lib/core/models/app_state.dart` — add `lastShownCharacterStage` (String, default `''`)

**Modify:** `lib/data/repositories/app_state_repository.dart` — persist new field

**Modify:** `lib/core/providers/app_state_provider.dart` — add `updateCharacterStage(String)` method

### 2E: Barrel exports

**Modify:** `lib/core/models/models.dart` — add 4 new exports (achievement_entry, achievement_data, lifetree_data, breathing_params, character_stage)

**Then run:** `dart run build_runner build --delete-conflicting-outputs`

---

## Task 3: Services / Engines (Pure Logic)

All services follow the StreakEngine pattern: `abstract final class` with static methods, no state.

### 3A: CharacterEngine

**New:** `lib/core/services/character_engine.dart`

- `stageForDays(int days)` → CharacterStage
- `stageName/stageDescription/stageMinDays` helpers
- Thresholds: sprout=0, ember=1, flame=7, blaze=14, phoenix=30, nova=60, cosmos=90

### 3B: AchievementEngine

**New:** `lib/core/services/achievement_engine.dart`

- `AchievementDef` class: id, title, description, icon, category
- `static const definitions` — 18 achievements across 6 categories
- `checkNewAchievements(...)` — takes all relevant counts, returns newly earned IDs

**Achievement definitions (18):**

| Category | ID | Title | Condition |
|----------|----|-------|-----------|
| streak | `streak_1` | "First Step" | 1-day streak |
| streak | `streak_7` | "One Week Warrior" | 7-day streak |
| streak | `streak_14` | "Fortnight Fighter" | 14-day streak |
| streak | `streak_30` | "Monthly Master" | 30-day streak |
| streak | `streak_60` | "Double Down" | 60-day streak |
| streak | `streak_90` | "Brain Rewired" | 90-day streak |
| pledge | `pledge_first` | "First Promise" | 1 pledge |
| pledge | `pledge_streak_7` | "Promise Keeper" | 7 consecutive pledge days |
| pledge | `pledge_streak_30` | "Oath of Steel" | 30 consecutive pledge days |
| journal | `journal_first` | "Dear Diary" | 1 journal entry |
| journal | `journal_10` | "Reflective Soul" | 10 entries |
| journal | `journal_streak_7` | "Daily Scribe" | 7 entries in 7 consecutive days |
| exercise | `exercise_first` | "Mindful Beginner" | 1 exercise |
| exercise | `exercise_10` | "Zen Practitioner" | 10 exercises |
| exercise | `exercise_all_types` | "Well-Rounded" | 1 of each type |
| urge | `urge_first` | "Faced the Storm" | 1 urge tracked |
| urge | `urge_10` | "Storm Rider" | 10 urges tracked |
| special | `lifetree_3` | "Tree Tender" | 3 Lifetree nodes unlocked |

### 3C: StatsEngine

**New:** `lib/core/services/stats_engine.dart`

Pure computation functions:
- `totalCleanDays`, `averageStreakLength`, `longestStreak` (from StreakData)
- `pledgeRate` (from PledgeData + totalDays)
- `journalFrequency` (from JournalData + totalDays)
- `streakHistoryLengths` (for bar chart)
- `moodTrend` (for line chart, last N days)
- `exerciseBreakdown` (for pie chart, by type)
- `urgesByHour`, `urgesByDayOfWeek` (for urge patterns)

### 3D: LifetreeEngine

**New:** `lib/core/services/lifetree_engine.dart`

- `LifetreeNode` class: id, title, description, category (enum), unlockCondition, position (Offset 0-1), isComingSoon
- `LifetreeUnlockCondition` class: minStreakDays, minExercises, minJournalEntries
- `static const nodes` — 9 nodes across 4 categories
- `isUnlockable(node, context)`, `nodesForCategory(cat)`, `connections` (line pairs)

**Lifetree nodes (9):**

| ID | Category | Title | Unlock Condition | Content |
|----|----------|-------|-----------------|---------|
| `breathing_478` | breathing | "4-7-8 Relaxing Breath" | streak >= 3 | BreathingParams(4,7,8,4) |
| `breathing_55` | breathing | "5-5 Equal Breath" | streak >= 7 | BreathingParams(5,0,5,6) |
| `breathing_627` | breathing | "6-2-7 Energizing Breath" | streak >= 14 | BreathingParams(6,2,7,5) |
| `journal_deep` | journaling | "Deep Reflection" | streak >= 5 | 5 new prompts |
| `journal_gratitude` | journaling | "Gratitude Practice" | 10 journal entries | 5 new prompts |
| `journal_future` | journaling | "Future Self Letters" | streak >= 14 | 5 new prompts |
| `meditation_body_scan` | meditation | "Body Scan" | 5 exercises | New guided screen |
| `soundscape_cosmic` | soundscapes | "Cosmic Drift" | — | Coming soon |
| `soundscape_nebula` | soundscapes | "Nebula Rain" | — | Coming soon |

### 3E: JournalPromptsEngine

**New:** `lib/core/services/journal_prompts_engine.dart`

- `defaultPrompts` — existing 6 prompts
- `deepReflectionPrompts`, `gratitudePrompts`, `futureSelfPrompts` — 5 each
- `allUnlockedPrompts(Set<String> unlockedNodeIds)` — merges base + unlocked

---

## Task 4: Repositories

### 4A: AchievementRepository

**New:** `lib/data/repositories/achievement_repository.dart`

Standard Hive pattern: `Box<AchievementData>`, key `'achievement_data'`, get/save/delete.

### 4B: LifetreeRepository

**New:** `lib/data/repositories/lifetree_repository.dart`

Standard Hive pattern: `Box<LifetreeData>`, key `'lifetree_data'`, get/save.

**Modify:** `lib/data/repositories/repositories.dart` — add 2 exports

**Depends on:** Task 2

---

## Task 5: Providers

### 5A: AchievementNotifier

**New:** `lib/core/providers/achievement_provider.dart`

- `achievementRepositoryProvider` (override at bootstrap)
- `achievementNotifierProvider` → `AchievementNotifier extends Notifier<AchievementData?>`
- `build()` — loads from repo
- `checkAndAward(...)` — reads streak/pledge/journal/exercise/urge/lifetree providers, calls AchievementEngine, persists new awards, returns newly earned IDs
- `unlockedIds` getter

### 5B: LifetreeNotifier

**New:** `lib/core/providers/lifetree_provider.dart`

- `lifetreeRepositoryProvider` (override at bootstrap)
- `lifetreeNotifierProvider` → `LifetreeNotifier extends Notifier<LifetreeData?>`
- `build()` — loads from repo
- `unlockNode(String nodeId)` — adds to list, persists
- `isNodeUnlocked(String nodeId)`, `unlockedCount` getter

**Modify:** `lib/core/providers/providers.dart` — add 2 exports

**Depends on:** Tasks 3, 4

---

## Task 6: Bootstrap (main.dart)

**Modify:** `lib/main.dart`

1. Register 3 new adapters: `AchievementEntryAdapter()`, `AchievementDataAdapter()`, `LifetreeDataAdapter()`
2. Open 2 new boxes in `Future.wait`: `Hive.openBox<AchievementData>('achievement_data')`, `Hive.openBox<LifetreeData>('lifetree_data')`
3. Create 2 repos from boxes
4. Add 2 overrides to `ProviderScope`

**Result:** 18 adapters, 12 boxes, 12 provider overrides

**Depends on:** Tasks 2, 4, 5

---

## Task 7: Routing

**Modify:** `lib/routing/route_names.dart` — add:
```
static const badges = '/profile/badges';
static const statistics = '/profile/statistics';
static const lifetree = '/library/lifetree';
static const bodyScan = '/library/meditate/body-scan';
```

**Modify:** `lib/routing/app_router.dart` — add 4 new GoRoute entries + update breathing exercise builder to accept `BreathingParams` extras

**No dependencies** — forward references to screens

---

## Task 8: Character Evolution UI

### 8A: CustomPainter characters (7 painters)

**New directory:** `lib/features/home/widgets/characters/`

7 painter files, one per stage. Each is a `CustomPainter` accepting `animationValue` (0-1) for idle pulse. Geometric space creatures:
- `sprout_painter.dart` — tiny seed with faint glow rings
- `ember_painter.dart` — small flickering particle cluster
- `flame_painter.dart` — geometric flame shape with inner eye
- `blaze_painter.dart` — expanding multi-point star
- `phoenix_painter.dart` — bird-like silhouette with wing arcs
- `nova_painter.dart` — radial burst with concentric rings
- `cosmos_painter.dart` — galaxy mandala with orbital paths

**New:** `lib/features/home/widgets/characters/character_painter_factory.dart` — factory `characterPainterFor(CharacterStage, double animValue)`

### 8B: CharacterDisplay widget

**New:** `lib/features/home/widgets/character_display.dart`

`ConsumerStatefulWidget`:
- Watches streak to compute stage via `CharacterEngine.stageForDays(days)`
- Compares with `appState.lastShownCharacterStage` — triggers evolution animation on stage change
- Idle: repeating `AnimationController` (2s) for pulse
- Evolution: separate `AnimationController` (1.5s) — scale down old → fade → scale up new
- Size: ~120x120

### 8C: StreakCard integration

**Modify:** `lib/features/home/widgets/streak_card.dart`

Insert `CharacterDisplay(days: days)` between `DayOrbsRow` and the sub-label. Pass `days` prop.

### 8D: Reset handling

**Modify:** `lib/features/home/home_screen.dart`

In `_showResetDialog`, after `resetStreak()` and `celebrateMilestone(0)`, add `updateCharacterStage('')`.

**Depends on:** Tasks 3A, 6

---

## Task 9: Enhanced Day Orbs (Milestone Path)

### 9A: Grade enrichment

**Modify:** `lib/features/home/widgets/day_orbs_row.dart`

Extend `_Grade` with optional `milestoneTitle` and `hasCharacter` fields. Set for 30/60/90-day grades:
- 30d → "True Freedom" + character (phoenix)
- 60d → "Master of Control" + character (nova)
- 90d → "Hero of Light" + character (cosmos)

### 9B: Character art at milestone positions

In `_GradeOrb`, when `hasCharacter && !isLocked`, render small (30x30) `CustomPaint` with the milestone's character painter above the orb.

### 9C: Tappable orb dialog

**New:** `lib/features/home/widgets/orb_detail_dialog.dart`

Wrap `_GradeOrb` in `GestureDetector`. On tap, show dialog with: larger orb visual, milestone title, character preview (if applicable), science message from StreakEngine, day/lock status.

### 9D: Constellation lines

**New:** `lib/features/home/widgets/constellation_lines_painter.dart`

Subtle glowing dotted lines connecting adjacent orbs behind the PageView. `CustomPainter` using `AppColors.primary.withValues(alpha: 0.15)`.

**Depends on:** Task 8A (character painters)

---

## Task 10: Achievement / Badge UI

### 10A: Badge collection screen

**New:** `lib/features/achievements/badge_collection_screen.dart`

ConsumerWidget, full-screen route from Profile. Grid of 18 badges (3 columns), grouped by category. Unlocked = colored + date, locked = greyed + lock overlay.

### 10B: Badge tile widget

**New:** `lib/features/achievements/widgets/badge_tile.dart`

Circular icon with gradient (unlocked) or dark muted (locked) background. Title + subtitle below.

### 10C: Achievement toast

**New:** `lib/features/achievements/widgets/achievement_toast.dart`

Slide-down SnackBar-like notification: badge icon + "Achievement Unlocked: {title}". Auto-dismisses 3s.

### 10D: HomeScreen achievement checking

**Modify:** `lib/features/home/home_screen.dart`

Add `_achievementsChecked` flag. After milestone check, call `achievementNotifier.checkAndAward()`. Show toast for newly earned.

### 10E: Profile integration

**Modify:** `lib/features/profile/profile_screen.dart`

Add 2 nav tiles between stats row and Settings:
1. "Achievements" — icon: military_tech, shows unlocked/total count, navigates to `/profile/badges`
2. "Statistics" — icon: bar_chart, navigates to `/profile/statistics`

Watch `achievementNotifierProvider` for unlocked count.

**Depends on:** Tasks 5A, 7

---

## Task 11: Statistics Dashboard

### 11A: Statistics screen

**New:** `lib/features/statistics/statistics_screen.dart`

ConsumerWidget watching streak/pledge/journal/urge/exercise providers. Calls StatsEngine for computations. Scrollable layout:
1. Header stats row: 3 cards (total clean days, longest streak, avg streak)
2. Streak history BarChart
3. Mood trends LineChart (last 30 days)
4. Exercise breakdown PieChart
5. Additional stats: pledge rate, journal frequency, urge peak hour/day

### 11B: Chart widgets

**New:** `lib/features/statistics/widgets/streak_history_chart.dart` — fl_chart BarChart, primary gradient bars, dark theme
**New:** `lib/features/statistics/widgets/mood_trend_chart.dart` — fl_chart LineChart, gradient fill, mood 0-4 y-axis
**New:** `lib/features/statistics/widgets/exercise_pie_chart.dart` — fl_chart PieChart, per-type colors

**Depends on:** Tasks 2A (fl_chart), 3C, 7

---

## Task 12: Lifetree Screen

### 12A: Constellation tree visualization

**New:** `lib/features/lifetree/lifetree_screen.dart`

ConsumerWidget, full-screen from Library. Watches lifetree + streak + exercise + journal providers. Renders constellation tree + unlock progress summary.

**New:** `lib/features/lifetree/widgets/lifetree_canvas.dart`

`CustomPaint` with `LifetreeCanvasPainter`:
- Subtle star dots background
- Constellation lines between connected nodes (brighter if both ends unlocked)
- Node circles at `LifetreeNode.position` coordinates (scaled to canvas)
- Unlocked: bright gradient + category icon + glow
- Unlockable: dimmer + pulsing border
- Locked: dark fill + lock icon
- Coming soon: dashed border

Four branches from center: Breathing (top-left), Journaling (top-right), Meditation (bottom-left), Soundscapes (bottom-right).

### 12B: Node interaction dialog

**New:** `lib/features/lifetree/widgets/lifetree_node_dialog.dart`

Tapping a node shows `AppBottomDialog` with:
- Title, description, category badge
- Lock state text: "Reach a 7-day streak to unlock" / "Ready to unlock!" / "Unlocked"
- Action button: "Unlock" → `lifetreeNotifier.unlockNode(id)` then navigate to content, or "Start" if already unlocked
- Coming soon badge if applicable

Navigation from dialog:
- Breathing nodes → `context.push(Routes.breathingExercise, extra: BreathingParams(...))`
- Journal nodes → `context.push(Routes.journalEntry)` (unlocked prompts auto-appear)
- Body scan → `context.push(Routes.bodyScan)`

### 12C: Library integration

**Modify:** `lib/features/library/library_screen.dart`

Replace Lifetree placeholder: subtitle → "Unlock bonus content", onTap → `context.push(Routes.lifetree)`.

**Depends on:** Tasks 3D, 5B, 7

---

## Task 13: Lifetree Content Integration

### 13A: Parameterize breathing exercise

**Modify:** `lib/features/exercises/breathing_exercise_screen.dart`

Add constructor params: `inhaleSeconds`, `holdSeconds`, `exhaleSeconds`, `totalCycles`, `title`, `patternLabel` (all with defaults matching current 4-4-4 / 5 cycles).

Compute cycle duration dynamically. Update phase boundaries in `_onTick`. Update display labels.

**Modify:** `lib/features/exercises/widgets/breathing_circle.dart`

Accept `inhaleEnd` and `holdEnd` params (default 0.33/0.66) for scale computation.

### 13B: Body scan meditation

**New:** `lib/features/exercises/body_scan_screen.dart`

ConsumerStatefulWidget. 10 guided steps with text + timer (~3 min total). Uses `AnimationController` with total duration. Records completion as exercise type `'body_scan'`.

**Modify:** `lib/features/exercises/widgets/exercise_completion_card.dart` — add `'body_scan'` label
**Modify:** `lib/features/exercises/meditate_screen.dart` — add 4th exercise card for Body Scan

### 13C: Journal prompt integration

**Modify:** `lib/features/journal/widgets/journal_prompt_chips.dart`

Make it a `ConsumerWidget`. Read `lifetreeNotifierProvider`. Merge base prompts + prompts from `JournalPromptsEngine.allUnlockedPrompts(unlockedNodeIds)`.

**Depends on:** Tasks 3E, 5B, 7

---

## Task 14: Wiring & Polish

### 14A: Achievement + Lifetree cross-reference
Ensure `lifetree_3` achievement checks `lifetreeNotifier.unlockedCount >= 3`.

### 14B: Barrel exports verification
Verify all models.dart, providers.dart, repositories.dart barrel exports are complete.

### 14C: flutter analyze
Run `flutter analyze` and fix any issues.

### 14D: CLAUDE.md update
Update: current state, project structure, tech stack (add fl_chart), key files, model typeIds, phase status.

### 14E: build_runner
Run `dart run build_runner build --delete-conflicting-outputs` for generated adapters.

**Depends on:** All tasks

---

## Dependency Graph (Execution Order)

```
Parallel:  Task 1 (Spec) + Task 2 (Models+Dep) + Task 7 (Routing)
Then:      Task 3 (Engines) → Task 4 (Repos) → Task 5 (Providers) → Task 6 (Bootstrap)
Parallel:  Task 8 (Character UI) + Task 11 (Stats Dashboard)
Then:      Task 9 (Enhanced Orbs, needs 8A)
Parallel:  Task 10 (Achievements UI) + Task 12 (Lifetree Screen) + Task 13 (Lifetree Content)
Then:      Task 14 (Polish)
```

---

## File Inventory

**New files (~36):**
- 5 models (+ 3 generated .g.dart)
- 5 services/engines
- 2 repositories
- 2 providers
- 8 character painters + factory
- 1 character display widget
- 2 orb enhancement widgets
- 3 achievement feature files
- 4 statistics feature files
- 3 lifetree feature files
- 1 body scan exercise

**Modified files (~18):**
- `pubspec.yaml` — fl_chart
- `lib/main.dart` — 3 adapters, 2 boxes, 2 repos, 2 overrides
- `lib/core/models/app_state.dart` — lastShownCharacterStage
- `lib/core/models/models.dart` — 5 exports
- `lib/core/providers/app_state_provider.dart` — updateCharacterStage
- `lib/core/providers/providers.dart` — 2 exports
- `lib/data/repositories/app_state_repository.dart` — new SharedPrefs key
- `lib/data/repositories/repositories.dart` — 2 exports
- `lib/routing/route_names.dart` — 4 routes
- `lib/routing/app_router.dart` — 5 route entries + breathing extras
- `lib/features/home/home_screen.dart` — achievement check + character reset
- `lib/features/home/widgets/streak_card.dart` — CharacterDisplay insertion
- `lib/features/home/widgets/day_orbs_row.dart` — milestone enrichment + tappable + constellation
- `lib/features/profile/profile_screen.dart` — 2 nav tiles
- `lib/features/library/library_screen.dart` — replace Lifetree placeholder
- `lib/features/exercises/breathing_exercise_screen.dart` — parameterize
- `lib/features/exercises/widgets/breathing_circle.dart` — phase boundaries
- `lib/features/exercises/widgets/exercise_completion_card.dart` — body_scan label
- `lib/features/exercises/meditate_screen.dart` — body scan card
- `lib/features/journal/widgets/journal_prompt_chips.dart` — Lifetree prompts
- `CLAUDE.md` — update docs

---

## Bootstrap Final State

After Phase 4: **18 Hive adapters**, **12 boxes**, **12 provider overrides**

---

## Verification (End-to-End)

1. **Cold start** — 12 Hive boxes open, no crashes
2. **Character evolution** — start at Sprout, advance streak → character changes, evolution animation plays once per stage, revert on reset
3. **Achievements** — complete actions → badges unlock → toast notification → badge collection screen shows unlocked/locked
4. **Enhanced orbs** — scroll carousel → see character art at 30/60/90 → tap orb → detail dialog with milestone info
5. **Statistics** — Profile → Statistics → charts render with real data (or empty state), streak history + mood trends + exercise breakdown
6. **Lifetree** — Library → Lifetree → constellation tree renders → locked/unlockable/unlocked nodes display correctly → unlock a node → navigate to content
7. **Lifetree breathing** — unlock breathing node → start exercise → custom pattern plays correctly (4-7-8 or 5-5 or 6-2-7)
8. **Lifetree journaling** — unlock journal node → new prompts appear in journal entry chips
9. **Lifetree body scan** — unlock body scan → guided steps → completion recorded
10. **Profile** — shows Achievements tile (with count) + Statistics tile → both navigate correctly
11. **Persistence** — kill app → reopen → achievements + lifetree unlocks persist
12. **Theme** — all new screens use gradient background, design tokens, dark card styling
