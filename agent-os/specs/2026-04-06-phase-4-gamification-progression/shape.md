# Phase 4 Shape — Gamification & Progression

## Scope

Add gamification and progression systems that reward recovery progress and sustain long-term motivation: character evolution, achievement badges, enhanced milestone path, statistics dashboard, and lifetree (skill tree unlocking bonus content).

## Key Decisions

- **Character art**: Programmatic CustomPainter creatures (geometric space aesthetic). No external SVG/Lottie assets — can be swapped later.
- **Charts**: fl_chart library for statistics dashboard (BarChart, LineChart, PieChart).
- **Lifetree**: Unlocks NEW bonus content (3 breathing patterns, 3 journal prompt sets, 1 body scan exercise, 2 coming-soon soundscapes). Existing features stay fully accessible — no gating.
- **Milestone Path**: Enhance existing Day Orbs carousel rather than building a separate screen. Add character art at 30/60/90 day positions, tappable orb detail dialogs, constellation lines.
- **No isPremium flags**: Keep lean. Phase 5 can add paywall gating later.
- **Character stage in SharedPreferences**: Track lastShownCharacterStage in AppState (not Hive) since it's a simple string.

## What Was Built

### New Models (Hive-persisted, typeIds 15-17)
- **AchievementEntry** (15) — id, unlockedAt
- **AchievementData** (16) — entries list container
- **LifetreeData** (17) — unlockedNodeIds list

### Non-Hive Models
- **CharacterStage** — enum with 7 stages (sprout through cosmos)
- **BreathingParams** — parameterized breathing exercise config

### New Services
- **CharacterEngine** — stage mapping from streak days
- **AchievementEngine** — 18 achievement definitions + condition checking
- **StatsEngine** — pure stat computation from existing data
- **LifetreeEngine** — 9 node definitions + unlock conditions
- **JournalPromptsEngine** — 3 new prompt sets (15 prompts total)

### New Providers
- **achievementNotifierProvider** — badge tracking and awarding
- **lifetreeNotifierProvider** — node unlock tracking

### New Repositories
- AchievementRepository, LifetreeRepository

### New Screens
- **BadgeCollectionScreen** — Grid of 18 achievements (unlocked/locked)
- **StatisticsScreen** — Dashboard with fl_chart charts
- **LifetreeScreen** — Constellation tree visualization
- **BodyScanScreen** — Guided body scan meditation

### New Widgets
- 7 CharacterPainter CustomPainters (Sprout through Cosmos)
- CharacterDisplay — animated character on home screen
- OrbDetailDialog — tappable orb milestone details
- ConstellationLinesPainter — lines connecting orbs
- BadgeTile, AchievementToast
- StreakHistoryChart, MoodTrendChart, ExercisePieChart
- LifetreeCanvas, LifetreeNodeDialog

### New Dependency
- `fl_chart: ^0.69.0`

### Integration
- Home screen: Character display in streak card, achievement checking
- Profile screen: 2 new nav tiles (Achievements, Statistics)
- Library screen: Lifetree placeholder replaced with real navigation
- Breathing exercise: Parameterized durations for Lifetree variants
- Journal prompts: Lifetree-unlocked prompt sets merged in
- Meditate screen: Body scan exercise card added
