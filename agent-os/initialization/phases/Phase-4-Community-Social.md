# Phase 4: Community & Social

## Goal

Build the anonymous community layer for peer support. This phase requires a backend (Firebase/Supabase) for user authentication and real-time data.

## Scope

### 1. Backend Setup

- Firebase or Supabase project setup
- Anonymous authentication (no email required to start)
- Optional email linking for account recovery
- Firestore/Postgres database schema for community data
- Security rules — users can only read community posts, write their own

### 2. Anonymous Community Feed

- Post types: win, struggle, question, milestone
- Reaction system (support emoji reactions, not likes)
- Character limit on posts
- Pull-to-refresh, infinite scroll
- No usernames — just anonymous identifiers ("Warrior #4821")
- Report/block functionality

### 3. Accountability Partners

- Opt-in pairing system
- Anonymous chat between partners
- Partner streak visibility (motivate each other)
- Ability to send encouragement/nudge
- Un-pair option

### 4. Community Stats

- "X people quitting with you right now"
- Community streak counter (combined days)
- Daily active users count
- Weekly community highlights

### 5. Moderation

- Automated content filtering (profanity, triggering content)
- User reporting system
- Admin review queue (basic)
- Auto-hide reported content

## Dependencies on Future Phases

- Phase 5: Premium community features (priority support, exclusive channels)

## Definition of Done

- [ ] Users can post and react to community content anonymously
- [ ] Accountability partner pairing works
- [ ] Community stats display on home screen
- [ ] Content moderation prevents harmful content
- [ ] Backend handles concurrent users reliably
