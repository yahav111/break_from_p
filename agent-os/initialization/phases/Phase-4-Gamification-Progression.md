# Phase 4: Gamification & Progression

## Goal

Add gamification and progression systems that reward recovery progress and keep users motivated long-term: character evolution, milestones, achievements, detailed statistics, and a skill tree.

## Scope

### 1. Character Evolution System

- Streak-based avatar displayed prominently on home screen
- Characters evolve as streak grows:
  - "Sprout" (0 days) — starting state, small seedling character
  - "Ember" (1+ days) — first evolution, gaining energy
  - Additional characters at 7, 14, 30, 60, 90 days (exact characters TBD, need illustration assets)
- Character shown on home screen streak card area
- Evolution animation when character upgrades
- Character reverts on streak reset (back to Sprout)
- Requires custom character illustration assets (SVG or Lottie)
- Characters also appear in the Milestone Path

### 2. Milestones & Achievements

- Badge system for key milestones (7 days, 30 days, 90 days, 1 year, etc.)
- Achievement unlocks with celebration animation
- Badge collection view
- Consecutive pledge badges
- Journal streak badges

### 3. Milestone Path with Characters

- Vertical scrollable space-themed path (distinct from badge system in section 2)
- Locked milestones at key intervals:
  - 30 days: "True Freedom" — with unique character illustration
  - 60 days: "Master of Control" — with unique character illustration
  - 90 days: "Hero of Light" — with unique character illustration
- Visual journey showing progress along the path
- Locked milestones appear greyed/locked, unlocked ones are vibrant
- Each milestone has a celebration screen when unlocked
- English titles
- Requires custom character/illustration assets per milestone
- Integrates with Character Evolution system (characters appear on path)

### 4. Statistics Dashboard

- Detailed stats screen (separate from home)
- Streak history chart (bar chart over time)
- Average streak length
- Total clean days
- Pledge completion rate
- Journal entry frequency
- Mood trends over time
- Best day of week / time patterns

### 5. Lifetree

- Progress/skill tree system where recovery progress unlocks content
- Tree structure with branches representing different recovery areas
- Unlockable nodes: new meditation exercises, soundscapes, journal prompts, breathing techniques
- Progression tied to streak length, journal consistency, pledge streaks, and exercises completed
- Visual tree representation (space-themed — constellation tree or nebula branches)
- Accessible from Library screen under "Lifetree" category
- Encourages exploration of all app features

## Dependencies on Future Phases

- Phase 5: Premium stats features and additional content behind paywall
- Character Evolution and Lifetree assets may be expanded as premium content in Phase 5

## Definition of Done

- [ ] Character evolves on home screen based on current streak length
- [ ] Character reverts to Sprout on streak reset
- [ ] Badge system awards achievements at milestones
- [ ] Milestone Path displays locked/unlocked milestones with character art
- [ ] Stats dashboard shows meaningful data visualizations
- [ ] Lifetree shows progression and unlocks content based on user activity
