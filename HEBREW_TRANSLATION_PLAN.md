# Hebrew Translation Plan — Quittr

## Context

המשתמש רוצה לתרגם את כל האפליקציה מאנגלית לעברית. השלבים 1-4 בפיתוח הושלמו וכעת יש כ-680 מחרוזות דוברות-משתמש ב-17 מודולי פיצ'רים + 5 שירותי ליבה.

הגישה שנבחרה: **החלפה ישירה** של מחרוזות אנגלית בעברית בקוד Dart, ללא תשתית i18n (flutter_localizations + .arb). זה מחליף קצב פיתוח מהיר במחיר גמישות עתידית למספר שפות.

מה לא משתנה: שמות שדות במודלים, מפתחות אחסון Hive, שמות מחלקות/פונקציות/משתנים, שמות קבצי נכסים, הערות בקוד, Hive typeIds, לוגים.

---

## Approach

1. החלפה בקוד של כל מחרוזת אנגלית דוברת-משתמש במקבילה העברית.
2. הגדרת locale עברי ב-`MaterialApp.router` כך ש-Flutter יציג דיאלוגים/פקדים מובנים (Material/Cupertino) בעברית ויפעיל `TextDirection.rtl` אוטומטית.
3. תיקון 3 קבצים שמשתמשים ב-`Alignment.centerLeft/centerRight` (לפי סריקת ה-RTL) במקום `.centerStart/End`.
4. פונט Rubik הנוכחי כבר תומך בעברית — אין צורך לשנות פונט.

---

## Implementation Phases

### Phase A — Framework Setup (~15 דקות)
- הוספת תלות `flutter_localizations` מ-Flutter SDK ב-`pubspec.yaml`.
- ב-`lib/app.dart`, עדכון `MaterialApp.router` עם:
  - `localizationsDelegates`: `GlobalMaterialLocalizations.delegate`, `GlobalWidgetsLocalizations.delegate`, `GlobalCupertinoLocalizations.delegate`
  - `supportedLocales`: `[Locale('he', 'IL')]`
  - `locale`: `Locale('he', 'IL')` — לכפות עברית ללא תלות בהגדרות המכשיר
- `flutter pub get`

### Phase B — RTL Fixes (~30 דקות)
תיקון 3 קבצים שזוהו ב-audit:
- `lib/design_system/components/app_button.dart` — `Alignment.centerLeft/Right` → `.centerStart/End`
- `lib/design_system/theme/component_themes.dart` — אותו דבר
- `lib/features/quiz/widgets/quiz_progress_bar.dart` — אותו דבר

לאחר מכן, הרצה על סימולטור ובדיקה ויזואלית של:
- סדר עמודי bottom nav (צריך להתהפך כי זו עברית)
- כיוון chevrons/חצים חוזרים (Flutter מטפל אוטומטית ב-Icons.arrow_back כש-TextDirection.rtl)
- כיוון מילוי progress bars
- 7 ציירי דמויות (character painters) + LifetreeCanvas — לפי ה-audit הם position-agnostic, אבל הצצה ויזואלית בסימולטור חשובה

### Phase C — Core Services (~1-2 שעות, 105 מחרוזות)
החלפת מחרוזות inline ב:
1. `lib/core/services/character_engine.dart` — 7 שלבי דמות × (שם + תיאור) = 14 מחרוזות
2. `lib/core/services/achievement_engine.dart` — 19 הישגים × (כותרת + תיאור) = 37 מחרוזות
3. `lib/core/services/lifetree_engine.dart` — 9 נקודות × (שם + תיאור) = 18 מחרוזות
4. `lib/core/services/journal_prompts_engine.dart` — 21 פרומפטים
5. `lib/core/services/streak_engine.dart` — 5 אבני דרך × (כותרת + תיאור + מסר מדעי) ≈ 15 מחרוזות

### Phase D — Features (~6-8 שעות, ~573 מחרוזות)
החלפה feature-by-feature, מהקטן לגדול, עם אימות ויזואלי אחרי כל פיצ'ר:

| # | Feature | Strings | Path |
|---|---------|---------|------|
| 1 | welcome | 5 | `lib/features/welcome/` |
| 2 | shell (bottom nav) | 5 | `lib/features/shell/` |
| 3 | quiz | 4 | `lib/features/quiz/` |
| 4 | achievements | 3 | `lib/features/achievements/` |
| 5 | profile | 8 | `lib/features/profile/` |
| 6 | paywall | 10 | `lib/features/paywall/` |
| 7 | lifetree | 10 | `lib/features/lifetree/` |
| 8 | soundscapes | 11 | `lib/features/soundscapes/` |
| 9 | statistics | 20 | `lib/features/statistics/` |
| 10 | library | 22 | `lib/features/library/` |
| 11 | journal | 25 | `lib/features/journal/` |
| 12 | home | 38 | `lib/features/home/` |
| 13 | urge_tracker | 45 | `lib/features/urge_tracker/` |
| 14 | panic_mode | 48 | `lib/features/panic_mode/` |
| 15 | settings | 53 | `lib/features/settings/` |
| 16 | exercises | 56 | `lib/features/exercises/` |
| 17 | onboarding | 210 | `lib/features/onboarding/` |

כל פיצ'ר: לעבור על `screen.dart`, על קבצי `widgets/`, ועל ברלים שמייצאים טקסט.

### Phase E — Dynamic Strings & Dates (~1 שעה)
- תצוגת תאריך ב-`lib/features/settings/` — להשתמש ב-`intl` `DateFormat(...,'he_IL')`
- שמות חודשים/ימי שבוע — `DateFormat.MMMM('he_IL')`, `DateFormat.EEEE('he_IL')`
- טיימרים (תרגילים): מספרים נשארים, רק מילות יחידה — "seconds"→"שניות", "minutes"→"דקות"
- מונה ימים: `"Day $days"` → `"יום $days"`, `"$days day streak"` → `"רצף של $days ימים"`
- לצורך פשטות, משתמשים ב-"ימים" לכל ערך (מקובל ב-UI עברי)

### Phase F — Verification (~2 שעות)
```bash
flutter pub get
flutter analyze       # ללא שגיאות
flutter run -d <sim>  # iOS simulator + Android emulator
```

Walk-through מלא:
- Welcome → onboarding 38 מסכים (כל השלבים A-H) → Home
- כל 5 לשוניות ה-bottom nav
- Settings (פרופיל, התראות, date picker של quit date — חייב להציג עברית נייטיבית)
- Panic mode (מצלמה + כלי התמודדות)
- 4 תרגילים (breathing, urge surfing, grounding, body scan)
- Urge tracker (intensity slider, triggers, chart labels)
- Achievements screen + toast של unlock
- Statistics (3 צ'ארטים של fl_chart — לוודא שלייבלים ציריים בעברית)
- Lifetree (tap על כל 9 הנקודות, דיאלוגים)
- Journal (entry creation, mood selector, prompt chips, calendar view)
- 4 soundscapes
- כל הדיאלוגים המודאליים (milestone celebration, pledge submission, relapse confirmation)

בדיקות ויזואליות:
- Overflow של טקסט (עברית לעיתים קצרה/ארוכה מאנגלית)
- כיוון layout (bottom nav הפוך, alignments תקינים)
- Dialogs מובנים (date picker, snackbars) בעברית

---

## Terminology Standards

טבלת מונחים עקבית לכל הפרויקט:

| English | עברית |
|---------|-------|
| streak | רצף |
| relapse | החלקה (לא "כישלון" — טון חומל) |
| pledge | התחייבות |
| urge | דחף |
| urge surfing | גלישה על דחף |
| brain rewire | חיווט מחדש של המוח |
| panic mode | מצב מצוקה |
| milestone | אבן דרך |
| achievement | הישג |
| lifetree | עץ החיים |
| journal | יומן |
| meditation | מדיטציה |
| breathing | נשימה |
| grounding | התמקדות / הארקה |
| body scan | סריקת גוף |
| soundscape | נוף קולי |
| reasons for quitting | סיבות להפסיק |

---

## Critical Files

**Config:**
- `pubspec.yaml`
- `lib/app.dart`

**RTL fixes:**
- `lib/design_system/components/app_button.dart`
- `lib/design_system/theme/component_themes.dart`
- `lib/features/quiz/widgets/quiz_progress_bar.dart`

**Services** (`lib/core/services/`):
- `character_engine.dart`, `achievement_engine.dart`, `lifetree_engine.dart`, `journal_prompts_engine.dart`, `streak_engine.dart`

**Features** — כל 17 התיקיות תחת `lib/features/`

**הערות מפתח עבריות קיימות בקוד** (לא user-facing, אבל ראוי להכיר):
- `lib/design_system/components/app_search_bar.dart` (שורה 69)
- `lib/design_system/components/app_fade_in_image.dart` (שורות 5, 19)
- `lib/design_system/components/app_bottom_nav.dart`

---

## Risks & Notes

1. **שינויים לא-מקומיים בענף**: לענף הנוכחי (`moshe_brance`) יש שינויים לא-מחויבים בקבצי onboarding (`phase_f_social_proof/recovery_graph_page.dart`, `phase_h_paywall/custom_plan_page.dart`, `phase_h_paywall/recovery_plan_page.dart`). לפני תרגום האונבורדינג כדאי לוודא שהתוכן יציב ולא ייכתב מחדש.

2. **onboarding הוא 30% מהמחרוזות** (210/680). אופציה לחלק לתתי-פאזות לפי `phase_a` עד `phase_h` כדי שלא ייצא PR ענק אחד.

3. **Hebrew plurals**: בעברית יש יחיד/זוגי/רבים בחלק מהשמות ("יום אחד", "יומיים", "3 ימים"). לפשטות ב-UI, שימוש ב-"ימים" לכל ערך מספרי ≥1 הוא מקובל.

4. **Text overflow**: עברית לרוב קצרה יותר מאנגלית, אבל עלולה להאריך משפטים מסוימים. Audit ויזואלי ב-Phase F חיוני.

5. **אייקונים כיווניים**: Flutter אוטומטית הופך `Icons.arrow_back` / `chevron_right` כש-`TextDirection.rtl`. SVG מותאמים (אם יש) עלולים לדרוש טיפול ידני — לבדוק.

6. **Native pickers**: `showDatePicker` ו-`CupertinoDatePicker` יציגו עברית אוטומטית בזכות `GlobalMaterial/CupertinoLocalizations.delegate`.

7. **הערכת מאמץ כוללת**: 10-14 שעות עבודה + verification מקיף. לא one-shot — מומלץ לחלק ל-2-3 PRs:
   - PR 1: Phase A + B + C (תשתית, RTL, services)
   - PR 2: Phase D items 1-16 (כל הפיצ'רים חוץ מ-onboarding)
   - PR 3: Phase D item 17 (onboarding) + Phase E + F

---

## Verification Commands

```bash
# After each phase
flutter pub get
flutter analyze
flutter test

# Full verification
flutter run -d <ios_simulator>
flutter run -d <android_emulator>
```

בסיום התרגום, הרצה ידנית של המסלולים:
1. Fresh install → welcome → onboarding (כל המסכים) → home
2. Quiz → pledge submission
3. Panic mode → camera → coping tools → back
4. Exercises (כל 4) עד הסוף
5. Urge tracker → log urge
6. Settings → change quit date → see date picker
7. Journal → entry + mood + prompt + calendar
8. Statistics → כל 3 הצ'ארטים
9. Lifetree → tap כל 9 הנקודות
10. Achievements → scroll, verify toast on unlock
