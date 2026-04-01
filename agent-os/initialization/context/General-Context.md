# Quittr — General Context

## What Is Quittr?

Quittr is a mobile app that helps people quit pornography addiction. It combines streak tracking, daily pledges, brain rewire progress visualization, journaling, meditation exercises, and emergency intervention tools into a premium, discreet experience.

## Current State (as of 2026-04-01)

Phase 1 (Project Foundation) and Phase 2 (Core Features) are **complete**. The app has a full onboarding flow, real-time streak tracking, daily pledges, panic mode with camera, milestone celebrations, notifications, settings, relapse tracking, and reasons for quitting. Phase 3 (Engagement Tools) is next.

### What exists:

- **Design System** (`lib/design_system/`) — Complete token system, reusable components, light/dark themes
- **Routing** (`lib/routing/`) — go_router with redirect logic, StatefulShellRoute for bottom nav, full-screen routes for Settings and Panic Mode
- **State Management** (`lib/core/providers/`) — Riverpod providers for AppState, UserProfile, StreakData, Quiz, LiveStreak, Pledges, Relapses, Reasons, NotificationPreferences
- **Data Models** (`lib/core/models/`) — UserProfile, StreakData, StreakRecord, AppState, QuizQuestion, PledgeData, RelapseData, RelapseEntry, ReasonsData, MilestoneInfo, NotificationPreferences
- **Repositories** (`lib/data/repositories/`) — AppState, UserProfile, Streak, Pledge, Relapse, Reasons, NotificationPreferences repositories
- **Services** (`lib/core/services/`) — StreakEngine (daysSince, formatDuration, milestones, brainRewireProgress), NotificationService
- **App Bootstrap** (`lib/main.dart`) — Async init of 6 Hive boxes + SharedPreferences, 7 repository overrides
- **Welcome Screen** — App entry with "Start Quiz" navigation
- **Quiz Screen** — 7-step dynamic flow: name → 5 assessment questions → quit date picker
- **Onboarding Screen** — Notification permission request
- **Paywall Screen** — Subscription plan selection (completes onboarding)
- **Home Screen** — Live streak (d/h/m/s), brain rewire %, pledge card, reasons section, stats row (streak/pledges/relapses), quick actions, milestone celebration dialogs
- **Settings Screen** — Profile editing, notification preferences, quit date management
- **Panic Mode Screen** — Full-screen emergency intervention with QUITTR header, rounded camera card (front selfie mirror with simulated fallback), cycling motivational banner, side-effects cards, branching flows (coping tools / relapse confirmation)
- **Profile Screen** — Avatar, stats summary, settings navigation
- **Navigation Shell** — Bottom nav with 4 tabs (Home, Library, Journal, Profile)
- **Placeholder Screens** — Library, Journal (coming in Phase 3)
- **Shared Widgets** — Star field background animation
- **Tests** — Unit tests for StreakEngine (including formatDuration, milestones), models, QuizNotifier

### What doesn't exist (coming in Phase 3+):

- Journal entries and mood tracking
- Meditation/breathing exercises
- Urge tracker
- Soundscapes (ambient audio)
- Library screen content
- Character evolution / gamification
- Statistics dashboard
- In-app purchases
- Backend integration / authentication

## Design Language

- **Theme:** Dark mode with space/cosmos aesthetic
- **Colors:** Deep navy backgrounds (#0A0D2E, #080B22), purple primary, green secondary, orange tertiary
- **Star field:** Animated star background on key screens (not Home — feels more grounded)
- **Typography:** Clean, modern hierarchy (Rubik font)
- **Spacing:** Consistent token-based 8-point grid system

## Monetization Model

- Freemium with subscription
- Monthly: ₪32/month
- Yearly: ₪99.90/year (₪8.32/month)
- Premium features: personalized plan, advanced stats

## Target Platforms

- Primary: iOS, Android
- Secondary: Web, macOS, Windows, Linux
