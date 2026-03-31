# Quittr — General Context

## What Is Quittr?

Quittr is a mobile app that helps people quit pornography addiction. It combines streak tracking, daily pledges, brain rewire progress visualization, journaling, meditation exercises, and emergency intervention tools into a premium, discreet experience.

## Current State (as of 2026-03-30)

The project has a **design system and static UI screens** built in Flutter. No business logic, navigation, state management, or persistence exists yet.

### What exists:
- **Design System** (`lib/design_system/`) — Complete token system (colors, spacing, typography, radius, shadows), reusable components (buttons, cards, modals, scaffolds, etc.), light/dark themes
- **Welcome Screen** — App entry/splash
- **Onboarding Screen** — Feature introduction with notifications prompt
- **Quiz Screen** — Assessment questionnaire (static, hardcoded question)
- **Paywall Screen** — Subscription plan selection (monthly ₪32, yearly ₪8.32/mo)
- **Home Screen** — Dashboard with streak card, stats row, quick actions
- **Showcase Screen** — Design system demo (currently set as home in main.dart)
- **Shared Widgets** — Star field background animation

### What doesn't exist:
- Navigation / routing
- State management
- Local storage / persistence
- Backend integration
- Business logic (streak calculation, pledge tracking, etc.)
- Real data models
- Authentication
- In-app purchases

## Design Language

- **Theme:** Dark mode with space/cosmos aesthetic
- **Colors:** Deep navy backgrounds (#0A0D2E, #080B22), purple primary, green secondary, orange tertiary
- **Star field:** Animated star background on key screens
- **Typography:** Clean, modern hierarchy
- **Spacing:** Consistent token-based spacing system

## Monetization Model

- Freemium with subscription
- Monthly: ₪32/month
- Yearly: ₪99.90/year (₪8.32/month)
- Premium features: personalized plan, advanced stats

## Target Platforms

- Primary: iOS, Android
- Secondary: Web
