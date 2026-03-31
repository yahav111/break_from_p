# Phase 3: Engagement Tools

## Goal

Give users daily coping tools and a content hub to deepen the recovery experience: journaling, meditation exercises, urge tracking, soundscapes, and a library screen to contain them all.

## Scope

### 1. Journal

- Daily journal entry (free-form text)
- Mood selector (emoji-based: great, good, okay, struggling, bad)
- Journal prompts — suggested topics for reflection
- Journal history with calendar view
- Search/filter entries
- Journal accessible from bottom nav and Panic Mode flow

### 2. Meditation & Exercises

- Guided breathing exercise (animated visual)
- Urge surfing technique (timed guided exercise)
- Grounding exercises (5-4-3-2-1 sensory technique)
- Timer with ambient sounds
- Exercise completion tracking
- Quick access from home screen and Panic Mode "I'm thinking of relapsing" flow

### 3. Urge Tracker

- Quick "I'm having an urge" button
- Log urge intensity (1-10)
- Log trigger category (boredom, stress, loneliness, etc.)
- Urge patterns visualization
- Track time of day, day of week patterns
- Connects to emergency/coping tools flow

### 4. Soundscapes

- Ambient sound player for relaxation and urge mitigation
- Sound categories: Campfire, Ocean, Rain, Forest (4 minimum)
- Playback controls: play/pause, volume, timer (auto-stop after X minutes)
- Background audio support (keeps playing when app is minimized)
- Accessible from Library screen and as a tool in Panic Mode/emergency flow
- Audio files bundled with app or streamed (consider app size impact)
- Use `just_audio` or `audioplayers` Flutter package

### 5. Library Screen

- New dedicated tab in bottom navigation (replaces Community placeholder)
- Content hub with categories:
  - **Mood** — mood tracking and mood-based content/suggestions
  - **Meditate** — container for meditation and breathing exercises (from section 2)
  - **Lifetree** — progress/skill tree (Phase 4)
  - **Soundscapes** — ambient sound player (from section 4)
- Grid or card layout for category selection
- Each category opens into its dedicated sub-screen
- Space theme consistent with rest of app
- Bottom nav order: Home, Library, Journal, Profile

## Dependencies on Future Phases

- Phase 4 will add Lifetree content to the Library screen
- Phase 5: Additional soundscapes and premium content behind paywall

## Definition of Done

- [ ] Users can write and review journal entries with mood tracking
- [ ] At least 3 meditation/breathing exercises are functional
- [ ] Urge tracker logs and visualizes urge patterns
- [ ] At least 4 soundscapes play with background audio support
- [ ] Library screen is accessible from bottom navigation with categories
- [ ] Bottom navigation updated: Home, Library, Journal, Profile
