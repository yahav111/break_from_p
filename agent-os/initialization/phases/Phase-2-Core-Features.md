# Phase 2: Core Features

## Goal

Build the essential daily-use features: full streak engine with real-time display, daily pledges, brain rewire progress, notifications, and settings screen.

## Scope

### 1. Full Streak Engine

- Real-time countdown/up display (days, hours, minutes, seconds)
- Streak history — track past streaks with start/end dates
- Longest streak record
- Streak reset with confirmation dialog and optional reason
- "Emergency" button — quick access to coping tools when tempted

### 2. Daily Pledges

- Morning pledge prompt (push notification trigger)
- Pledge card on home screen — "I pledge to stay clean today"
- Pledge history — track which days user made a pledge
- Pledge streak (consecutive days of pledging)
- Pledge confirmation animation

### 3. Brain Rewire Progress

- 90-day progress visualization (circular or linear progress)
- Milestones at key points: 7 days, 14 days, 30 days, 60 days, 90 days
- Science-based messaging at each milestone
- Visual feedback when milestones are reached
- Reset brain rewire on streak reset

### 4. Notifications

- Request notification permission (connect to onboarding screen)
- Morning pledge reminder (configurable time)
- Streak milestone celebrations
- Daily motivation quotes
- "Check-in" reminders (evening)
- Use `flutter_local_notifications`

### 5. Settings Screen

- Profile editing (name, quit date)
- Notification preferences (toggle each type, set times)
- Reset streak option
- About / Privacy Policy / Terms
- App version info
- "Delete all data" option

## Dependencies on Future Phases

- Phase 3 will add journal entries accessible from "Emergency" flow
- Phase 4 will add community features to settings
- Phase 5 will add subscription management to settings

## Definition of Done

- [ ] Real-time streak counter updates live on home screen
- [ ] User can make and track daily pledges
- [ ] Brain rewire progress shows accurate 90-day progress
- [ ] Notifications work for pledges and milestones
- [ ] Settings screen is fully functional
- [ ] All data persists and syncs correctly
