import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/streak_data.dart';
import '../../../infrastructure/firebase/firestore_paths.dart';
import '../contracts/data_repository.dart';

class FirestoreStreakRepository implements DataRepository<StreakData> {
  FirestoreStreakRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.doc(FirestorePaths.streakData(_uid));

  @override
  StreakData? get() => null;

  @override
  Future<void> save(StreakData data) =>
      _doc.set(data.toJson(), SetOptions(merge: true));

  @override
  Future<void> delete() => _doc.delete();

  Future<StreakData?> fetch() async {
    final snap = await _doc.get();
    if (!snap.exists || snap.data() == null) return null;
    return StreakData.fromJson(snap.data()!);
  }
}
