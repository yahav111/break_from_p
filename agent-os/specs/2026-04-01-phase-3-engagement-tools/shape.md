# Phase 3 Shape — Engagement Tools

## Scope

Give users daily coping tools and a content hub to deepen recovery: journaling, meditation exercises, urge tracking, soundscapes, and a library screen.

## Key Decisions

- **Lean Phase 3**: No isPremium flags, analytics stubs, or subscription provider stubs. Data models are extensible via copyWith — Phase 4-5 can add fields later.
- **Audio**: just_audio package with bundled MP3 assets (~20KB placeholders, to be replaced with real ambient audio).
- **Mood storage**: Int (0-4) in Hive, Dart enum for display only. Avoids extra Hive type registration.
- **Trigger/exercise types**: Stored as String, not Hive enums. Extensible without migration.
- **No external chart library**: Urge patterns use custom Container-based bar charts.
- **No calendar library**: Calendar view uses GridView.builder.

## What Was Built

### New Models (Hive-persisted, typeIds 9-14)
- **JournalEntry** (9) — id, date, content, mood, prompt, createdAt, updatedAt
- **JournalData** (10) — entries list container
- **UrgeEntry** (11) — id, timestamp, intensity, trigger, note
- **UrgeData** (12) — entries list + totalUrges counter
- **ExerciseRecord** (13) — id, completedAt, exerciseType, durationSeconds
- **ExerciseData** (14) — records list + totalCompleted counter

### New Providers
- **journalNotifierProvider** — CRUD for journal entries
- **urgeNotifierProvider** — Urge logging
- **exerciseNotifierProvider** — Exercise completion tracking
- **soundscapeNotifierProvider** — Ephemeral playback state (no Hive)

### New Repositories
- JournalRepository, UrgeRepository, ExerciseRepository

### New Screens
- **JournalScreen** — Entry list, search, mood filter, FAB
- **JournalEntryScreen** — Editor with mood selector, prompts
- **JournalHistoryScreen** — Calendar view with mood dots
- **MeditateScreen** — Exercise list with completion counts
- **BreathingExerciseScreen** — Animated 4-4-4 breathing circle
- **UrgeSurfingScreen** — Timed guided 6-step exercise
- **GroundingScreen** — Interactive 5-4-3-2-1 sensory technique
- **UrgeTrackerScreen** — Multi-step urge logging flow
- **UrgePatternsScreen** — Time-of-day bars, top triggers, history
- **SoundscapesScreen** — 4 ambient sounds with playback controls
- **LibraryScreen** — Content hub with 4 category cards (Mood, Meditate, Lifetree placeholder, Soundscapes)
- **MoodHistoryScreen** — Mood trends + urge summary

### New Services
- **AudioService** — Wraps just_audio: play, pause, stop, volume, sleep timer, looping

### New Dependencies
- `just_audio: ^0.9.40` — Audio playback

### Platform Changes
- iOS: UIBackgroundModes audio in Info.plist
- Android: FOREGROUND_SERVICE permission in AndroidManifest.xml

### Integration
- Home screen: Wired "Meditate", "Journal", "Track Urge" quick action chips
- Panic Mode: CopingPlaceholder replaced with CopingTools (real navigation to exercises/journal)
