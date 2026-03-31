# Phase 1: Project Foundation

## Goal

Transform the existing static UI screens into a working app with navigation, state management, local persistence, and data models. After this phase, a user can open the app, go through the quiz, set a quit date, and see their streak on the home screen.

## Scope

### 1. Navigation & Routing

- Set up `go_router` for declarative routing
- Define routes: `/welcome`, `/quiz`, `/onboarding`, `/paywall`, `/home`
- App flow: Welcome → Quiz → Onboarding → Paywall → Home
- Returning users skip to Home
- Bottom navigation on Home (future screens: Home, Library, Journal, Profile)

### 2. State Management

- Set up `flutter_riverpod` as state management solution
- Create providers for: user profile, streak data, app state
- Wrap app in `ProviderScope`

### 3. Data Models

- `UserProfile` — name, quit date, quiz answers, subscription status
- `StreakData` — quit date, current streak days, longest streak, reset history
- `AppState` — onboarding completed, first launch

### 4. Local Storage

- Set up `shared_preferences` for simple key-value data
- Set up `hive` for structured data (user profile, streak history)
- Create repository pattern for data access

### 5. Connect Existing Screens

- Wire up Welcome screen with "Get Started" navigation
- Make Quiz screen functional — collect answers, navigate forward
- Connect Onboarding to actual notification permission request
- Make Paywall screen navigate to Home (subscription logic in Phase 5)
- Update Home screen to show real streak data from storage

### 6. Streak Engine (Basic)

- Calculate days since quit date
- Display real streak on home screen
- Handle reset (user can reset their streak)
- Persist streak data locally

## Dependencies on Future Phases

- Phase 2 will expand the streak engine with time display and brain rewire calculation
- Phase 3 will add journal, meditation, and library features (bottom nav placeholders needed)
- Phase 5 will implement actual paywall logic (for now, paywall just navigates forward)

## Key Decisions

- `go_router` over `Navigator 2.0` — simpler API, good enough for this app
- `riverpod` over `bloc` — less boilerplate, modern approach
- `hive` over `isar` — lighter, sufficient for offline-first data
- Repository pattern — abstracts storage, easy to swap implementations later

## Definition of Done

- [ ] User can launch app → see welcome → go through quiz → onboarding → paywall → home
- [ ] Returning users go straight to home
- [ ] Home screen shows real streak count based on quit date
- [ ] User can reset streak
- [ ] All data persists between app restarts
- [ ] Navigation feels smooth with proper transitions
