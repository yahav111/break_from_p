# Quittr — Roadmap

## Phase 1: Project Foundation (MVP Core)

Establish the technical foundation: navigation, state management, local persistence, and connect existing UI screens into a working app flow.

- App navigation (welcome → quiz → onboarding → paywall → home)
- State management setup (Riverpod or Bloc)
- Local storage (shared_preferences / Hive)
- User profile & quit date storage
- Basic streak tracking (days since quit date)

## Phase 2: Core Features

Build the essential features that make the app useful day-to-day.

- **Streak Engine** — Real-time streak counter with time display, reset functionality
- **Daily Pledges** — Morning pledge commitment, pledge history
- **Brain Rewire Progress** — Science-based progress visualization (90-day rewire concept)
- **Notifications** — Smart reminders, streak milestone celebrations
- **Settings** — Profile, notification preferences, quit date management
- **Panic Mode** — Full emergency intervention with front camera mirror, motivational content, relapse side-effects cards, and branching flows ("I'm thinking of relapsing" / "I Relapsed")
- **Relapses Counter** — Persistent counter on home screen showing total lifetime relapse count
- **Reasons For Quitting** — Home screen section where user sets and reviews personal reasons for quitting

## Phase 3: Engagement Tools

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
