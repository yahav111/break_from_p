import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/achievement_data.dart';
import '../../../infrastructure/firebase/firestore_paths.dart';
import '../contracts/data_repository.dart';

class FirestoreAchievementRepository
    implements DataRepository<AchievementData> {
  FirestoreAchievementRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.doc(FirestorePaths.achievementData(_uid));

  @override
  AchievementData? get() => null;

  @override
  Future<void> save(AchievementData data) =>
      _doc.set(data.toJson(), SetOptions(merge: true));

  @override
  Future<void> delete() => _doc.delete();

  Future<AchievementData?> fetch() async {
    final snap = await _doc.get();
    if (!snap.exists || snap.data() == null) return null;
    return AchievementData.fromJson(snap.data()!);
  }
}
