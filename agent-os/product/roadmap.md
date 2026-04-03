# Quittr — Roadmap

## Phase 1: Project Foundation (MVP Core) ✅ COMPLETE

Establish the technical foundation: navigation, state management, local persistence, and connect existing UI screens into a working app flow.

- ✅ App navigation with go_router (welcome → quiz → onboarding → paywall → home)
- ✅ State management with Riverpod (Notifier API)
- ✅ Local storage (shared_preferences for AppState, Hive for UserProfile & StreakData)
- ✅ User profile & quit date storage via 7-step quiz flow
- ✅ Basic streak tracking (days since quit date, brain rewire %)
- ✅ Bottom navigation shell (Home, Library, Journal, Profile) with StatefulShellRoute
- ✅ Notification permission request (permission_handler)
- ✅ Streak reset with confirmation dialog
- ✅ Returning users skip onboarding (redirect logic)

## Phase 2: Core Features ✅ COMPLETE

Build the essential features that make the app useful day-to-day.

- ✅ **Streak Engine** — Real-time live streak (days/hours/minutes/seconds via liveStreakProvider), formatDuration, milestone detection
- ✅ **Daily Pledges** — PledgeData model, PledgeNotifier, PledgeCard on home screen, pledge history tracking
- ✅ **Brain Rewire Progress** — Milestone system (7/14/30/60/90 days), MilestoneInfo with science messages, MilestoneCelebrationDialog
- ✅ **Notifications** — flutter_local_notifications, NotificationPreferences model & provider, notification scheduling
- ✅ **Settings** — Full settings screen (/settings route), profile editing, notification preferences, quit date management
- ✅ **Panic Mode** — Full-screen emergency intervention (/panic route) with front camera mirror (camera package), motivational content, relapse side-effects, branching flows
- ✅ **Relapses Counter** — RelapseData/RelapseEntry models, RelapseNotifier, persistent counter on home screen
- ✅ **Reasons For Quitting** — ReasonsData model, ReasonsNotifier, ReasonsSection widget on home screen
- ✅ **Profile Screen** — Fully functional with avatar, stats summary, settings navigation (replaced placeholder)

## Phase 3: Engagement Tools ← NEXT

Give users daily coping tools and a content hub.

- **Journal** — Daily reflection entries, mood tracking
- **Meditation/Exercises** — Guided breathing, urge surfing exercises
- **Urge Tracker** — Log urges, identify triggers, track patterns
- **Soundscapes** — Ambient sound player (Campfire, Ocean, Rain, Forest) for urge mitigation and relaxation
- **Library Screen** — Dedicated content hub tab with categories: Mood, Meditate, Lifetree, Soundscapes

## Phase 4: Gamification & Progression

Add reward and progression systems that visualize growth.

- **Character Evolution** — Streak-based avatar that evolves: Sprout (0 days) → Ember (1+ days) → further characters at higher streaks
- **Milestones & Achievements** — Badge system, milestone celebrations
- **Milestone Path with Characters** — Vertical space-themed path with locked milestones at 30/60/90 days, each with unique character art
- **Statistics Dashboard** — Detailed stats, graphs, trends
- **Lifetree** — Progress/skill tree where users unlock new content and features as they advance in recovery

## Phase 5: Monetization & Growth

Implement the subscription model and growth features.

- **In-App Purchases** — RevenueCat integration, monthly/yearly plans
- **Personalized Recovery Plan** — AI-generated plans based on quiz answers
- **Analytics** — Firebase/Mixpanel for user behavior

## Phase 6: Polish & Launch

Final refinements for App Store / Play Store launch.

- **App Store Optimization** — Screenshots, description, metadata
- **Onboarding Refinement** — A/B test flows
- **Performance Optimization** — App size, load times
- **Crash Reporting** — Sentry/Crashlytics
- **Privacy Compliance** — GDPR, App Store guidelines for sensitive content
