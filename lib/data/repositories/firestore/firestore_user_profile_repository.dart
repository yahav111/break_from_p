import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/user_profile.dart';
import '../../../infrastructure/firebase/firestore_paths.dart';
import '../contracts/data_repository.dart';

class FirestoreUserProfileRepository implements DataRepository<UserProfile> {
  FirestoreUserProfileRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.doc(FirestorePaths.userProfile(_uid));

  @override
  UserProfile? get() => null; // Reads go through Hive.

  @override
  Future<void> save(UserProfile data) =>
      _doc.set(data.toJson(), SetOptions(merge: true));

  @override
  Future<void> delete() => _doc.delete();

  /// Direct Firestore fetch — used by SyncEngine for pull operations.
  Future<UserProfile?> fetch() async {
    final snap = await _doc.get();
    if (!snap.exists || snap.data() == null) return null;
    return UserProfile.fromJson(snap.data()!);
  }
}
