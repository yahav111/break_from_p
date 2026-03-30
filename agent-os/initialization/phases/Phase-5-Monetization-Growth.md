# Phase 5: Monetization & Growth

## Goal

Implement the subscription model, content blocking, personalized plans, analytics, and localization.

## Scope

### 1. In-App Purchases

- RevenueCat SDK integration
- Two plans: Monthly (₪32/mo), Yearly (₪99.90/yr)
- Connect paywall screen to actual purchase flow
- Restore purchases
- Receipt validation
- Subscription status provider — gate premium features
- Free tier: basic streak, pledges, limited journal entries
- Premium tier: everything

### 2. Content Blocker (Premium)

- iOS: Safari content blocker extension
- Android: VPN-based or accessibility service blocker
- Configurable block lists
- Block page with motivational message and emergency tools link
- Easy toggle on/off in settings

### 3. Personalized Recovery Plan (Premium)

- Use quiz answers to generate a personalized 90-day plan
- Daily tasks/goals based on recovery stage
- Adjusts based on user's urge patterns and journal entries
- Weekly plan review and adjustment
- Optional AI-generated insights (future consideration)

### 4. Analytics

- Firebase Analytics or Mixpanel integration
- Key events: app open, streak reset, pledge made, journal entry, exercise completed
- Funnel tracking: onboarding → quiz → paywall → conversion
- Retention metrics
- A/B testing framework for onboarding/paywall

### 5. Localization

- Set up `flutter_localizations` and `intl`
- Extract all strings to ARB files
- Hebrew (primary market) and English
- RTL support for Hebrew
- Date/time formatting per locale
- Currency formatting per locale

## Dependencies on Future Phases

- Phase 6: Final optimization of conversion funnels

## Definition of Done

- [ ] Users can purchase and manage subscriptions
- [ ] Content blocker works on iOS and Android
- [ ] Personalized plan generates from quiz data
- [ ] Analytics track key user events
- [ ] App works in Hebrew and English with proper RTL
