# Phase 2: Core Features

## Goal

Build the essential daily-use features: full streak engine with real-time display, daily pledges, brain rewire progress, notifications, settings, panic mode emergency system, relapse counting, and personal reasons for quitting.

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

### 6. Panic Mode

- Full-screen emergency intervention triggered from Panic Button on home screen
- Opens device front camera (selfie mirror) showing user's own face
- Displays bold motivational sentences overlay ("YOU'RE DOING THIS FOR A BETTER LIFE")
- Shows "Side Effects of Relapsing" cards (e.g., "REDUCED PERFORMANCE", "BRAIN FOG", "SHAME & GUILT")
- Two distinct action buttons:
  - "I'm thinking of relapsing" — keeps user in coping mode, surfaces more tools (breathing, journal, meditation)
  - "I Relapsed" — triggers streak reset flow with confirmation and reason logging
- Requires camera permission (request on first use, with explanation dialog)
- Must work without camera if permission denied (skip the mirror, keep rest of the flow)
- Works offline (no network dependency)
- Use `camera` Flutter package for front camera access

### 7. Relapses Counter

- Persistent counter tracking total lifetime relapses
- Visible on home screen alongside streak counter and "Til Sober" countdown
- Increments automatically when user confirms relapse via Panic Mode or streak reset
- Stored locally alongside streak data
- Only resets via "Delete all data" in settings (not on streak reset)
- Serves as honest accountability metric

### 8. Reasons For Quitting

- Home screen section displaying user's personal reasons for quitting
- Setup prompt during first use or accessible from home screen
- User can add multiple reasons (free text, with optional suggested reasons)
- Reasons displayed as cards/chips on home screen
- Edit/delete/reorder reasons from settings or home screen
- Reasons also shown during Panic Mode flow for additional motivation
- Stored locally

## Dependencies on Future Phases

- Phase 3 will add journal entries accessible from Panic Mode and "I'm thinking of relapsing" flow
- Phase 3 will add meditation/breathing exercises accessible from Panic Mode coping tools
- Phase 5 will add subscription management to settings

## Definition of Done

- [ ] Real-time streak counter updates live on home screen
- [ ] User can make and track daily pledges
- [ ] Brain rewire progress shows accurate 90-day progress
- [ ] Notifications work for pledges and milestones
- [ ] Settings screen is fully functional
- [ ] All data persists and syncs correctly
- [ ] Panic Mode opens front camera and displays motivational content
- [ ] Panic Mode branches correctly: "thinking of relapsing" shows coping tools, "I Relapsed" triggers reset
- [ ] Camera permission requested and handled gracefully (including denial)
- [ ] Relapses counter displays on home screen and increments on relapse
- [ ] User can set, view, edit, and delete personal reasons for quitting
- [ ] Reasons appear on home screen and within Panic Mode
