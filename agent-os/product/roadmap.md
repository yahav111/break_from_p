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

## Phase 3: Engagement & Retention

Add features that keep users coming back and deepen the recovery experience.

- **Journal** — Daily reflection entries, mood tracking
- **Meditation/Exercises** — Guided breathing, urge surfing exercises
- **Milestones & Achievements** — Badge system, milestone celebrations
- **Statistics Dashboard** — Detailed stats, graphs, trends
- **Urge Tracker** — Log urges, identify triggers, track patterns

## Phase 4: Community & Social

Build the anonymous community layer for peer support.

- **Anonymous Community Feed** — Share wins, ask for support
- **Accountability Partners** — Pair up for mutual support
- **Community Stats** — "2.1k people quitting with you"
- **Moderation** — Content moderation, reporting

## Phase 5: Monetization & Growth

Implement the subscription model and growth features.

- **In-App Purchases** — RevenueCat integration, monthly/yearly plans
- **Content Blocker** — Safari/browser content blocking (premium feature)
- **Personalized Recovery Plan** — AI-generated plans based on quiz answers
- **Analytics** — Firebase/Mixpanel for user behavior
- **Localization** — Multi-language support (Hebrew, English, etc.)

## Phase 6: Polish & Launch

Final refinements for App Store / Play Store launch.

- **App Store Optimization** — Screenshots, description, metadata
- **Onboarding Refinement** — A/B test flows
- **Performance Optimization** — App size, load times
- **Crash Reporting** — Sentry/Crashlytics
- **Privacy Compliance** — GDPR, App Store guidelines for sensitive content
