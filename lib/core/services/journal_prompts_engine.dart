/// Pure logic for journal prompt sets, including Lifetree-unlockable prompts.
abstract final class JournalPromptsEngine {
  /// Default prompts (always available).
  static const defaultPrompts = [
    'על מה אני אסיר תודה היום?',
    'מה היה הטריגר שלי היום?',
    'איך התמודדתי עם דחפים?',
    'איזו התקדמות הבחנתי בה?',
    'מה הייתי אומר לחבר במצב שלי?',
    'מהן המטרות שלי למחר?',
  ];

  /// Deep Reflection prompts (unlocked via Lifetree node 'journal_deep').
  static const deepReflectionPrompts = [
    'אילו דפוסים אני מבחין בהתנהגות שלי?',
    'מאיזה רגש אני נמנע כרגע?',
    'כשאני מדמיין את עצמי הטוב ביותר, איך הוא נראה?',
    'מה הייתי מאבד אם הייתי נכנע היום?',
    'מה למדתי על עצמי השבוע?',
  ];

  /// Gratitude prompts (unlocked via Lifetree node 'journal_gratitude').
  static const gratitudePrompts = [
    'מהם שלושה דברים שאני אסיר תודה עליהם היום?',
    'מי תמך בי במסע הזה?',
    'איזה ניצחון קטן אני יכול לחגוג היום?',
    'באיזה חלק מההחלמה שלי אני הכי גאה?',
    'איזה דבר טוב קרה שלא ציפיתי לו?',
  ];

  /// Future Self prompts (unlocked via Lifetree node 'journal_future').
  static const futureSelfPrompts = [
    'עצמי היקר לעתיד, אני רוצה שתדע...',
    'בעוד שנה, אני מקווה שהחיים שלי ייראו כך...',
    'האדם שאני הופך להיות היה אומר לי...',
    'איזו עצה עצמי בן 90 הימים היה נותן לי היום?',
    'אילו הרגלים אני בונה עכשיו שעצמי העתידי יודה לי עליהם?',
  ];

  /// Node ID → prompt set mapping.
  static const _nodePrompts = <String, List<String>>{
    'journal_deep': deepReflectionPrompts,
    'journal_gratitude': gratitudePrompts,
    'journal_future': futureSelfPrompts,
  };

  /// Returns all prompts available given the unlocked Lifetree node IDs.
  /// Always includes default prompts, plus any unlocked sets.
  static List<String> allUnlockedPrompts(Set<String> unlockedNodeIds) {
    final prompts = [...defaultPrompts];
    for (final entry in _nodePrompts.entries) {
      if (unlockedNodeIds.contains(entry.key)) {
        prompts.addAll(entry.value);
      }
    }
    return prompts;
  }
}
