# Plan — App Blocker / App Freezing (iOS + Android)

## Context

Quittr helps users quit porn addiction. A natural premium feature is letting users **block / freeze apps and websites** on their own device (e.g., Safari, Instagram, Reddit, Twitter) while on a streak, so the phone itself enforces their commitment. This is the single most-requested feature in this category and is what the real-world QUITTR app ships. Positioning it behind the Phase 5 paywall (RevenueCat) makes it the headline premium capability.

The research question was: **is this actually possible from a third-party app, and what does it cost?** Short answer: **yes on both platforms, but iOS requires Apple's explicit entitlement approval and ships native Swift extensions; Android uses an overlay/usage-stats workaround with weaker guarantees.**

---

## Research Findings

### iOS — Apple Screen Time API (FamilyControls + ManagedSettings + DeviceActivity)

- **It IS possible for a third-party app to block other apps**, via three frameworks working together:
  - `FamilyControls` → requests authorization + presents `FamilyActivityPicker` for the user to pick apps/categories/websites.
  - `ManagedSettings` → applies the shield (the actual block, rendered by iOS).
  - `DeviceActivity` → schedules when the shield is active (e.g., "always", "weekdays 8am–10pm").
- **Self-blocking mode exists** (iOS 16+): call `AuthorizationCenter.shared.requestAuthorization(for: .individual)`. This is the mode Quittr would use — adult user blocks themselves, no iCloud Family / parental account needed.
- **Minimum iOS**: 16.0 for `.individual` authorization. (Current project target is 13.0 — needs bumping.)
- **Requires Apple entitlement approval**: `com.apple.developer.family-controls` — requested from Apple Developer portal, reviewed by humans. Approval takes **1 day to ~4+ weeks** historically. Distribution entitlement is separate from dev entitlement — both needed.
- **Tokens are opaque**: `FamilyActivityPicker` returns `ApplicationToken` / `ActivityCategoryToken` blobs, NOT bundle IDs. You can't read "user blocked Instagram" — you just store the token and pass it to `ManagedSettingsStore`. This is a privacy feature of the API.
- **Known limitations** (per Frederik Riedel, "one sec" developer):
  - Tokens can randomly change — a shielded app's token may rotate, requiring a re-pick.
  - User can disable your app's Screen Time permission from iOS Settings → Screen Time at any time (no passcode protection for third parties).
  - From a shielded screen, your app can only do: nothing / close / reload. You **cannot** programmatically bring Quittr to the foreground from the shield. Workarounds use push notifications or URL schemes.
- **App Store precedent**: QUITTR, AppBlock, one sec, Opal, Jomo, ScreenZen, etc. are all shipping on the App Store using this API — self-blocking is an approved category.

### Android — no first-party equivalent

- No API that maps to Screen Time. Apps block other apps via three ingredients:
  - `PACKAGE_USAGE_STATS` (special permission, user-granted in Settings) → detects which app is foreground.
  - `SYSTEM_ALERT_WINDOW` → draws a blocking overlay on top.
  - Foreground service → keeps the detector alive.
- **Weaker guarantees**: user can disable the accessibility/usage-access permission, kill the service, or uninstall. Similar to iOS in determination level but the Android approach is well-trodden.

### Flutter plugin options

- **`flutter_screentime`** (github.com/ioridev/flutter_screentime) — supports **both iOS and Android**. Owns the Flutter API + Android overlay service + iOS native bridge. The host app still owns iOS extension targets, entitlements, signing, and shield UI.
- `screen_time_api_ios` (kboy-silvergym) — iOS-only, acknowledged as incomplete.

**Given the user's directive ("fastest/most efficient"), the recommendation is `flutter_screentime`.**

---

## Recommended Approach

Use **`flutter_screentime`** for both platforms. Gate the entire feature behind a premium flag (stub now, wire to RevenueCat in Phase 5).

On iOS the plugin handles the Flutter↔Swift bridge, but **Quittr's Xcode project still needs to grow three extension targets, an App Group, and the Family Controls entitlement**. That native work is unavoidable regardless of plugin choice — the plugin just saves us the MethodChannel boilerplate.

**Critical non-code blocker**: submit the Family Controls distribution entitlement request to Apple on **day 1** of implementation. It can take weeks, and without it the feature cannot ship.

---

## Implementation Plan

### Phase 0 — Pre-work (non-code, start immediately)

1. In Apple Developer portal, submit the request for `com.apple.developer.family-controls` distribution entitlement for the app's Team ID.
   - Use case summary: "Adult self-blocking tool for porn recovery. User picks apps/websites to shield while on their recovery streak."
2. Decide the App Group identifier (suggest `group.com.quittr.appblocker`). It must match across the app target and all extension targets.
3. Product decisions to answer (flagged under "Open questions" below).

### Phase 1 — iOS foundation

1. Bump iOS deployment target **13.0 → 16.0**:
   - `ios/Podfile` — `platform :ios, '16.0'`
   - `ios/Runner.xcodeproj/project.pbxproj` — all `IPHONEOS_DEPLOYMENT_TARGET` entries
   - `ios/Flutter/AppFrameworkInfo.plist` — `MinimumOSVersion`
2. Add capabilities to the `Runner` target in Xcode:
   - Family Controls
   - App Groups (add `group.com.quittr.appblocker`)
3. Update `ios/Runner/Runner.entitlements`:
   - Add `com.apple.developer.family-controls` = `true`
   - Add `com.apple.security.application-groups` = `[group.com.quittr.appblocker]`

### Phase 2 — iOS extensions (Xcode, Swift)

Create three extension targets, each signed with the same App Group. Use the Swift templates documented in `flutter_screentime`'s `doc/ios_extensions.md`.

1. **DeviceActivityMonitorExtension** — scheduling / re-applying shields across events.
2. **ShieldConfigurationExtension** — custom shield UI (Quittr-branded):
   - Dark navy gradient (match `AppColors`), star field silhouette, Quittr mark.
   - Current-streak line: "You're on day X. Keep going."
   - Primary button label: "Panic Mode".
3. **ShieldActionExtension** — button handlers on the shield:
   - Primary action → open Quittr via custom URL scheme `quittr://panic`.
   - Secondary action → close.

Each extension must declare the App Group entitlement so it can read the shared selection/schedule state written by the main app.

### Phase 3 — Android permissions & manifest

In `android/app/src/main/AndroidManifest.xml`, declare:

- `android.permission.SYSTEM_ALERT_WINDOW` (overlay)
- `android.permission.PACKAGE_USAGE_STATS` (special — user grants via Settings → Usage access)
- `android.permission.FOREGROUND_SERVICE` and `FOREGROUND_SERVICE_SPECIAL_USE`
- `android.permission.QUERY_ALL_PACKAGES` (to list launchable apps for the picker)

Register the plugin's foreground service (per plugin docs).

### Phase 4 — Flutter wiring (follows existing Lifetree pattern)

Reference files to mirror:
- `lib/core/providers/lifetree_provider.dart` (provider pattern)
- `lib/data/repositories/hive/hive_lifetree_repository.dart` (Hive repo pattern)
- `lib/features/lifetree/lifetree_screen.dart` (full-screen route pattern)

New files to create:

1. `pubspec.yaml` — add `flutter_screentime` dependency.
2. `lib/core/models/app_blocker_data.dart` — Hive type `@HiveType(typeId: 18)`:
   - `Uint8List? selectionBlob` — opaque `FamilyActivitySelection` Codable payload.
   - `bool isEnabled`.
   - `TimeOfDay? scheduleStart`, `TimeOfDay? scheduleEnd` (nullable → "always on").
   - Manual `copyWith`.
   - Generate adapter with `build_runner`.
3. `lib/data/repositories/hive/hive_app_blocker_repository.dart` — implements `DataRepository<AppBlockerData>`.
4. `lib/core/providers/app_blocker_provider.dart`:
   - `appBlockerRepositoryProvider` (abstract, overridden at bootstrap).
   - `appBlockerNotifierProvider` (Notifier).
   - Methods: `requestAuthorization()`, `pickApps()`, `enableShield()`, `disableShield()`, `updateSchedule(start, end)`.
5. `lib/main.dart` — open 13th Hive box, register adapter, override the new repo provider in `ProviderScope.overrides`.
6. `lib/features/app_blocker/app_blocker_screen.dart` — screen with:
   - Enabled toggle.
   - "Choose apps to block" button → calls `pickApps()` (shows iOS `FamilyActivityPicker` / Android picker).
   - Count of blocked apps/categories (tokens are opaque — show count, not names).
   - Schedule editor (optional — MVP can be always-on).
   - Status / last-change info.
   - `widgets/` subfolder for sub-components per project convention.
7. `lib/routing/route_names.dart` — add `static const appBlocker = '/app-blocker';`.
8. `lib/routing/app_router.dart` — register full-screen route (pattern per Lifetree / Statistics).
9. Entry point: add "App Blocker" card to the **Library** screen (`lib/features/library/`) — fits the content-hub pattern. Show a premium lock icon if not subscribed.

### Phase 5 — Premium gating

1. Create `lib/core/services/premium_gate.dart` with a single `isPremium` getter backed by SharedPreferences (stub).
2. Create `lib/features/paywall/premium_paywall_sheet.dart` — reusable bottom-sheet that promotes premium and routes to the existing paywall screen.
3. Gate:
   - The `/app-blocker` route (redirect to paywall if not premium).
   - The Library entry card (shows lock + triggers paywall sheet on tap).
4. Leave a clear TODO at the gate's single source of truth so Phase 5 can swap in RevenueCat without touching feature code.

### Phase 6 — Branded shield UI

In `ShieldConfigurationExtension` (Swift), compose a `ShieldConfiguration` with:
- `backgroundColor` → deep navy.
- `title` / `subtitle` → motivational copy + current streak (streak read from App Group shared UserDefaults, written by Flutter on streak change — add a one-line hook in `streak_provider` to mirror `currentStreakDays` into the shared container).
- `primaryButtonLabel` → "Panic Mode".
- `secondaryButtonLabel` → "Close".

### Phase 7 — Manual verification

Family Controls does **not** work on the iOS Simulator. You must test on real devices.

1. `flutter pub get` succeeds.
2. `flutter build ios --release` and `flutter build apk --release` succeed.
3. **iOS real device (iOS 16+)**: authorize → pick 3 apps (Instagram, Safari, YouTube) → enable → background Quittr → launch Instagram → see Quittr-branded shield → tap "Panic Mode" → Quittr opens to `/panic`.
4. **iOS**: toggle "Enabled" off in Quittr → launch Instagram → normal launch.
5. **Android real device**: grant Usage Access + Overlay permissions from in-app prompts → pick 3 apps → enable → launch Instagram → see overlay.
6. **Premium gate**: with stub `isPremium = false`, `/app-blocker` redirects to paywall; with `true`, feature works.
7. **Streak integration**: bump streak to 7, trigger a shield, confirm shield shows "day 7".

---

## Critical Files

**Create:**
- `lib/core/models/app_blocker_data.dart`
- `lib/core/providers/app_blocker_provider.dart`
- `lib/data/repositories/hive/hive_app_blocker_repository.dart`
- `lib/features/app_blocker/app_blocker_screen.dart` (+ `widgets/`)
- `lib/features/paywall/premium_paywall_sheet.dart`
- `lib/core/services/premium_gate.dart`
- Three Xcode extension targets under `ios/` (DeviceActivityMonitor, ShieldConfiguration, ShieldAction).

**Modify:**
- `pubspec.yaml` (add `flutter_screentime`)
- `ios/Podfile` (iOS 16)
- `ios/Runner.xcodeproj/project.pbxproj` (deployment target, extension targets, app group)
- `ios/Runner/Runner.entitlements` (Family Controls, App Groups)
- `ios/Flutter/AppFrameworkInfo.plist` (MinimumOSVersion)
- `ios/Runner/Info.plist` (URL scheme `quittr://` if not already present)
- `android/app/src/main/AndroidManifest.xml` (permissions, foreground service)
- `lib/main.dart` (new Hive box + repo override)
- `lib/routing/route_names.dart` (+ `appBlocker`)
- `lib/routing/app_router.dart` (route registration)
- `lib/features/library/library_screen.dart` (add entry card with premium lock)
- `lib/core/providers/streak_provider.dart` (mirror streak to App Group shared defaults — one line)

---

## Open Questions (to decide before / during Phase 1)

1. **Relapse flow**: when the user taps "I relapsed", should the shield auto-disable, auto-reset, or stay on? (Recommendation: keep ON — the shield is about friction to the pattern, not punishment.)
2. **Default schedule**: always-on, or a default window (e.g., 6am–midnight)? (Recommendation: always-on for MVP; schedule editor can be v2.)
3. **iOS-only first, or ship both together**? Android has weaker guarantees and is less on-brand with a space/cosmos polished feel. (Recommendation: ship iOS first — it's the premium flagship platform and has App Store precedent.) Confirm with user.
4. **Pre-empt Apple entitlement wait**: should we put the rest of the feature behind a feature flag so the build ships without the Family Controls entitlement until Apple approves?

---

## Risk & Blockers

- **Apple entitlement denial / delay** is the single largest risk. Mitigation: submit on day 1; justify with the "individual self-blocking for adult recovery" use case; point Apple at precedent apps (AppBlock, one sec, QUITTR).
- **iOS 16 min** cuts off iOS 13–15 users. Check current install base before committing.
- **Opaque tokens** mean we cannot show "Instagram" in the UI — we show "3 apps blocked". Product should confirm that's acceptable.

---

## Sources

- [A Developer's Guide to Apple's Screen Time APIs — Julius Brussee](https://medium.com/@juliusbrussee/a-developers-guide-to-apple-s-screen-time-apis-familycontrols-managedsettings-deviceactivity-e660147367d7)
- [Screen Time API documentation — Apple Developer](https://developer.apple.com/documentation/screentimeapidocumentation)
- [Requesting the Family Controls entitlement — Apple](https://developer.apple.com/documentation/familycontrols/requesting-the-family-controls-entitlement)
- [SwiftUI Tutorial: iOS App Blocker with Screen Time APIs — JC](https://medium.com/@jc_builds/building-a-powerful-ios-app-blocker-with-screen-time-apis-the-complete-guide-f6272bd00fc4)
- [Apple's Screen Time API has some major issues — riedel.wtf](https://riedel.wtf/state-of-the-screen-time-api-2024/)
- [flutter_screentime (ioridev)](https://github.com/ioridev/flutter_screentime)
- [screen_time_api_ios (kboy-silvergym)](https://github.com/kboy-silvergym/screen_time_api_ios)
- [Family Controls entitlement (bundle resources)](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.family-controls)
- [Meet the Screen Time API — WWDC21 (notes)](https://wwdcnotes.com/documentation/wwdcnotes/wwdc21-10123-meet-the-screen-time-api/)
