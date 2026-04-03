# Phase 2 Shape — Core Features

## Scope

Build all essential daily-use features: real-time streak, pledges, milestones, notifications, settings, panic mode, relapse tracking, and reasons for quitting.

## What Was Built

### New Models (Hive-persisted)
- **PledgeData** — Daily pledge tracking with pledge dates history
- **RelapseData** + **RelapseEntry** — Relapse counter with timestamped entries
- **ReasonsData** — User's personal reasons for quitting
- **StreakRecord** — Completed past streaks (start/end/days) for streak history
- **MilestoneInfo** — Milestone definitions with science-based messages
- **NotificationPreferences** — User notification scheduling preferences

### New Providers
- **liveStreakProvider** — Real-time streak ticker (updates every second with Duration)
- **pledgeNotifierProvider** — Daily pledge state and history
- **relapseNotifierProvider** — Relapse counter and entry logging
- **reasonsNotifierProvider** — Reasons for quitting CRUD
- **notificationPreferencesProvider** — Notification settings

### New Repositories
- PledgeRepository, RelapseRepository, ReasonsRepository, NotificationPreferencesRepository

### New Screens & Widgets
- **SettingsScreen** (`/settings`) — Profile editing, notification preferences, quit date management
- **PanicModeScreen** (`/panic`) — Full-screen emergency intervention with "QUITTR" header, "Panic Button" title, rounded camera card (front camera selfie mirror, simulated portrait fallback on simulator), cycling motivational text banner at bottom of camera card, side effects cards, branching flows ("I'm thinking of relapsing" red button / "I Relapsed" grey button), coping placeholders (Phase 3), relapse flow with reason input
- **PledgeCard** — Home screen daily pledge widget
- **ReasonsSection** — Home screen reasons for quitting display
- **MilestoneCelebrationDialog** — Celebration overlay at 7/14/30/60/90 days with science messages
- **ProfileScreen** — Replaced placeholder with full avatar, stats, settings nav

### Enhanced Existing
- **StreakEngine** — Added `formatDuration()`, `checkMilestone()`, `milestoneMessage()`, `highestMilestoneReached()`, milestone data map
- **StreakData** — Added `streakHistory` (List<StreakRecord>)
- **AppState** — Added `lastCelebratedMilestone` for tracking shown celebrations
- **HomeScreen** — Now ConsumerStatefulWidget with live streak, pledge card, reasons section, milestone detection
- **main.dart** — Expanded to 6 Hive boxes + 7 repository overrides

### New Dependencies
- `flutter_local_notifications: ^18.0.1` — Notification scheduling
- `camera: ^0.11.0+2` — Front camera for Panic Mode

### iOS Compliance
- Added `NSCameraUsageDescription` to Info.plist for camera permission
