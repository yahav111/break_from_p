# Implementation Prompts

Each prompt runs in a **fresh Claude Code session**. Enter **plan mode** before pasting.

---

## Phase 1 — Project Foundation

```
Implement Phase 1 of the Quittr product — Project Foundation.

Context gathering:
- Read ALL files in agent-os/initialization/context/
- Read the phase spec: agent-os/initialization/phases/Phase-1-Project-Foundation.md
- Skim future phase specs (Phase-2 through Phase-6) to understand what's coming — make foundation decisions that reduce future rework.

Ensure you are in plan mode, then run /agent-os:shape-spec to shape this implementation. Ask me to clarify anything ambiguous — scope, tech decisions, constraints — before proceeding.

Search CandleKeep for domain expertise to inform the plan. Topics: Flutter project structure, go_router navigation patterns, Riverpod state management architecture, Hive local storage, repository pattern in Flutter, mobile app scaffolding strategies, clean architecture for Flutter.

Produce the implementation plan. The final task should be:
→ Run /agent-os:discover-standards — walk me through selecting which discovered standards to save.
```



## Phase 2 — Core Features

```
Implement Phase 2 of the Quittr product — Core Features.

Context gathering:
- Read ALL files in agent-os/initialization/context/
- Read the phase spec: agent-os/initialization/phases/Phase-2-Core-Features.md
- Review existing Phase 1 implementation in the codebase — align with established patterns and conventions.
- Skim future phase specs (Phase-3 through Phase-6) to anticipate integration points and avoid decisions that create rework.

Ensure you are in plan mode, then run /agent-os:shape-spec to shape this implementation. Ask me to clarify anything ambiguous before proceeding.

Search CandleKeep for domain expertise to inform the plan. Topics: real-time streak counters in Flutter, Flutter camera package integration, notification scheduling with flutter_local_notifications, Riverpod provider patterns for complex state, commitment device UX patterns, emergency intervention UI design, mobile permission handling best practices.

Produce the implementation plan:
- First task: Run /agent-os:inject-standards — suggest relevant standards and let me choose which to inject.
- Final task: Run /agent-os:discover-standards — walk me through selecting which discovered standards to save.
```

---

## Phase 3 — Engagement Tools

```
Implement Phase 3 of the Quittr product — Engagement Tools.

Context gathering:
- Read ALL files in agent-os/initialization/context/
- Read the phase spec: agent-os/initialization/phases/Phase-3-Engagement-Tools.md
- Review existing Phase 1–2 implementation in the codebase — align with established patterns and conventions.
- Skim future phase specs (Phase-4 through Phase-6) to anticipate integration points and avoid decisions that create rework.

Ensure you are in plan mode, then run /agent-os:shape-spec to shape this implementation. Ask me to clarify anything ambiguous before proceeding.

Search CandleKeep for domain expertise to inform the plan. Topics: journaling UX patterns, mood tracking data models, guided meditation timer implementation, ambient audio playback in Flutter with just_audio, background audio on iOS and Android, content hub navigation patterns, urge tracking and CBT-based trigger logging.

Produce the implementation plan:
- First task: Run /agent-os:inject-standards — suggest relevant standards and let me choose which to inject.
- Final task: Run /agent-os:discover-standards — walk me through selecting which discovered standards to save.
```

---

## Phase 4 — Gamification & Progression

```
Implement Phase 4 of the Quittr product — Gamification & Progression.

Context gathering:
- Read ALL files in agent-os/initialization/context/
- Read the phase spec: agent-os/initialization/phases/Phase-4-Gamification-Progression.md
- Review existing Phase 1–3 implementation in the codebase — align with established patterns and conventions.
- Skim future phase specs (Phase-5 through Phase-6) to anticipate integration points and avoid decisions that create rework.

Ensure you are in plan mode, then run /agent-os:shape-spec to shape this implementation. Ask me to clarify anything ambiguous before proceeding.

Search CandleKeep for domain expertise to inform the plan. Topics: gamification systems in mobile apps, character evolution and avatar progression, Lottie and SVG animation in Flutter, achievement and badge system design, skill tree data structures, progress visualization patterns, chart libraries for Flutter statistics dashboards, milestone celebration UX.

Produce the implementation plan:
- First task: Run /agent-os:inject-standards — suggest relevant standards and let me choose which to inject.
- Final task: Run /agent-os:discover-standards — walk me through selecting which discovered standards to save.
```

---

## Phase 5 — Monetization & Growth

```
Implement Phase 5 of the Quittr product — Monetization & Growth.

Context gathering:
- Read ALL files in agent-os/initialization/context/
- Read the phase spec: agent-os/initialization/phases/Phase-5-Monetization-Growth.md
- Review existing Phase 1–4 implementation in the codebase — align with established patterns and conventions.
- Skim the Phase-6 spec to anticipate launch requirements and avoid decisions that create rework.

Ensure you are in plan mode, then run /agent-os:shape-spec to shape this implementation. Ask me to clarify anything ambiguous before proceeding.

Search CandleKeep for domain expertise to inform the plan. Topics: RevenueCat Flutter integration, in-app subscription flows for iOS and Android, paywall conversion optimization, Firebase Analytics event design, Mixpanel funnel tracking, AI-generated personalized plans, freemium gating strategies, receipt validation best practices.

Produce the implementation plan:
- First task: Run /agent-os:inject-standards — suggest relevant standards and let me choose which to inject.
- Final task: Run /agent-os:discover-standards — walk me through selecting which discovered standards to save.
```

---

## Phase 6 — Polish & Launch

```
Implement Phase 6 of the Quittr product — Polish & Launch.

Context gathering:
- Read ALL files in agent-os/initialization/context/
- Read the phase spec: agent-os/initialization/phases/Phase-6-Polish-Launch.md
- Review the full existing implementation (Phases 1–5) in the codebase — this phase integrates and polishes everything, so understanding current patterns and seams is critical.

Ensure you are in plan mode, then run /agent-os:shape-spec to shape this implementation. Ask me to clarify anything ambiguous before proceeding.

Search CandleKeep for domain expertise to inform the plan. Topics: Flutter performance profiling and optimization, Sentry and Crashlytics integration, App Store and Play Store submission requirements, sensitive content app review guidelines, GDPR compliance for mobile apps, accessibility auditing, TestFlight and staged rollout strategies, unit and widget testing in Flutter.

Produce the implementation plan:
- First task: Run /agent-os:inject-standards — suggest relevant standards and let me choose which to inject.
- Final task: Run /agent-os:discover-standards — walk me through selecting which discovered standards to save.
→ Run /agent-os:index-standards to rebuild the full index.
```
