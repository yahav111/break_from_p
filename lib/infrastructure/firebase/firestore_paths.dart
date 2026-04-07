/// Centralized Firestore document/collection path constants.
///
/// All user data lives under `users/{uid}/` with one subcollection
/// per data type, each containing a single `current` document.
abstract final class FirestorePaths {
  static String userDoc(String uid) => 'users/$uid';

  static String userProfile(String uid) =>
      'users/$uid/user_profile/current';

  static String streakData(String uid) =>
      'users/$uid/streak_data/current';

  static String pledgeData(String uid) =>
      'users/$uid/pledge_data/current';

  static String relapseData(String uid) =>
      'users/$uid/relapse_data/current';

  static String reasonsData(String uid) =>
      'users/$uid/reasons_data/current';

  static String journalData(String uid) =>
      'users/$uid/journal_data/current';

  static String urgeData(String uid) =>
      'users/$uid/urge_data/current';

  static String exerciseData(String uid) =>
      'users/$uid/exercise_data/current';

  static String achievementData(String uid) =>
      'users/$uid/achievement_data/current';

  static String lifetreeData(String uid) =>
      'users/$uid/lifetree_data/current';

  static String syncMeta(String uid) =>
      'users/$uid/_meta/sync';
}
