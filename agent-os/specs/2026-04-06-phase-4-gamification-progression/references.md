# Phase 4 References

## Key Files Studied

### lib/core/services/streak_engine.dart
- Pure static utility pattern (abstract final class)
- Milestone definitions at [7, 14, 30, 60, 90]
- MilestoneInfo model with title, description, scienceMessage
- Used as template for CharacterEngine, AchievementEngine, StatsEngine, LifetreeEngine

### lib/core/models/app_state.dart
- SharedPreferences-backed model (not Hive)
- copyWith pattern
- Extended with lastShownCharacterStage field

### lib/features/home/widgets/day_orbs_row.dart
- PageView.builder carousel with 17 _Grade milestones
- _OrbTier visual configs (colors, glow, rings)
- _GradeOrb with lock/unlock states
- _RingPainter CustomPainter for gradient rings
- Enhanced with milestone titles, character art, tappable dialogs, constellation lines

### lib/features/home/home_screen.dart
- ConsumerStatefulWidget pattern
- _checkMilestone() pattern — reused for _checkAchievements()
- _showResetDialog — extended with character stage reset

### lib/features/home/widgets/streak_card.dart
- Composition: DayOrbsRow + counters + progress bar
- CharacterDisplay widget inserted between orbs and counters

### lib/features/profile/profile_screen.dart
- ConsumerWidget with stat cards + nav tiles
- Extended with Achievements and Statistics nav tiles

### lib/features/library/library_screen.dart
- 2x2 LibraryCategoryCard grid
- Lifetree card placeholder replaced with real navigation

### lib/features/exercises/breathing_exercise_screen.dart
- AnimationController-based exercise with phases
- Parameterized: inhale/hold/exhale seconds + cycle count
- BreathingCircle widget adapted for dynamic phase boundaries

### lib/main.dart
- Bootstrap: 15→18 adapters, 10→12 boxes, 10→12 provider overrides
- Pattern: register adapters → open boxes in Future.wait → create repos → ProviderScope.overrides

### lib/data/repositories/exercise_repository.dart
- Template for AchievementRepository and LifetreeRepository
- Box<T>, static _key, get/save/delete pattern

### lib/core/providers/exercise_provider.dart
- Template for AchievementNotifier and LifetreeNotifier
- Repository provider throws → overridden at bootstrap
- Notifier build() loads from repo, methods mutate + persist
