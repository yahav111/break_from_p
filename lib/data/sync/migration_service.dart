import 'package:cloud_firestore/cloud_firestore.dart';

import '../../infrastructure/firebase/firestore_paths.dart';

/// Handles one-time data migration checks and status tracking.
abstract final class MigrationService {
  /// Checks if the user's data has already been migrated to Firestore.
  static Future<bool> isMigrationComplete(String uid) async {
    final doc =
        await FirebaseFirestore.instance.doc(FirestorePaths.syncMeta(uid)).get();
    return doc.exists && doc.data()?['migrationCompleted'] == true;
  }

  /// Checks if the user has existing cloud data (e.g., signing in
  /// on a new device). Returns true if any data document exists.
  static Future<bool> hasCloudData(String uid) async {
    final doc = await FirebaseFirestore.instance
        .doc(FirestorePaths.userProfile(uid))
        .get();
    return doc.exists;
  }
}
