import '../models/milestone_info.dart';

/// Pure calculation functions for streak-related logic.
/// No Flutter or storage dependencies — easy to unit test.
abstract final class StreakEngine {
  /// Milestone day markers for brain rewire progress.
  static const milestones = [7, 14, 30, 60, 90];

  /// Number of full days since [quitDate].
  static int daysSince(DateTime quitDate) {
    return DateTime.now().difference(quitDate).inDays;
  }

  /// Returns the larger of the current streak and the previous longest.
  static int longestStreak(int currentDays, int previousLongest) {
    return currentDays > previousLongest ? currentDays : previousLongest;
  }

  /// Brain rewire progress as a 0.0–1.0 fraction (based on 90-day target).
  static double brainRewireProgress(int days) {
    return (days / 90).clamp(0.0, 1.0);
  }

  /// Formats a [Duration] as "X ימים X שעות X דקות X שניות".
  static String formatDuration(Duration d) {
    final days = d.inDays;
    final hours = d.inHours.remainder(24);
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '$days ימים $hours שעות $minutes דקות $seconds שניות';
  }

  /// Returns [MilestoneInfo] if [days] exactly matches a milestone.
  static MilestoneInfo? checkMilestone(int days) {
    if (!milestones.contains(days)) return null;
    return _milestoneData[days];
  }

  /// Returns the science-based message for a milestone at [days].
  static String milestoneMessage(int days) {
    return _milestoneData[days]?.scienceMessage ?? '';
  }

  /// Returns the highest milestone that has been reached for [days].
  static int? highestMilestoneReached(int days) {
    int? highest;
    for (final m in milestones) {
      if (days >= m) highest = m;
    }
    return highest;
  }

  static const _milestoneData = <int, MilestoneInfo>{
    7: MilestoneInfo(
      days: 7,
      title: 'שבוע ראשון',
      description: 'שרדת את החלק הקשה ביותר.',
      scienceMessage:
          'המוח שלך מתחיל להפחית את ויסות-הירידה של קולטני הדופמין. '
          'תסמיני הגמילה כמו עצבנות וחשקים נמצאים בשיא '
          'אך יתחילו להתרכך.',
    ),
    14: MilestoneInfo(
      days: 14,
      title: 'שבועיים של עוצמה',
      description: 'נתיבים עצביים חדשים נבנים.',
      scienceMessage:
          'קליפת המוח הקדם-מצחית מחזירה שליטה על תגובות דחף. '
          'איכות השינה והריכוז משתפרים באופן מדיד, ככל שהמוח '
          'מכייל מחדש את מעגלי התגמול שלו.',
    ),
    30: MilestoneInfo(
      days: 30,
      title: 'חודש של חופש',
      description: 'שינוי הרגלים אמיתי תופס אחיזה.',
      scienceMessage:
          'צפיפות קולטני הדופמין גדֵלה בחזרה אל קו הבסיס. '
          'המוח שלך מוצא עכשיו יותר הנאה בפעילויות יומיומיות. '
          'המוטיבציה וויסות הרגשות מתחזקים באופן מורגש.',
    ),
    60: MilestoneInfo(
      days: 60,
      title: 'חודשיים של חופש',
      description: 'המוח שלך עובר חיווט מחדש עמוק.',
      scienceMessage:
          'הנתיבים העצביים שקשורים להרגל הישן נחלשים '
          'דרך גיזום סינפטי. דפוסים חדשים ובריאים יותר '
          'מתחזקים. הביטחון העצמי והשליטה העצמית בשיאם.',
    ),
    90: MilestoneInfo(
      days: 90,
      title: 'המוח חוּוט מחדש',
      description: 'הצלחת. המוח שלך התאפס.',
      scienceMessage:
          'מחקרים מצביעים על 90 יום כסף לשינוי '
          'נוירופלסטי משמעותי. מערכת הדופמין שלך חזרה במידה רבה '
          'לקו הבסיס. המשיכה הכפייתית מוחלפת בחופש אמיתי של בחירה.',
    ),
  };
}
