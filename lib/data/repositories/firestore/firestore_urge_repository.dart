import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/urge_data.dart';
import '../../../infrastructure/firebase/firestore_paths.dart';
import '../contracts/data_repository.dart';

class FirestoreUrgeRepository implements DataRepository<UrgeData> {
  FirestoreUrgeRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.doc(FirestorePaths.urgeData(_uid));

  @override
  UrgeData? get() => null;

  @override
  Future<void> save(UrgeData data) =>
      _doc.set(data.toJson(), SetOptions(merge: true));

  @override
  Future<void> delete() => _doc.delete();

  Future<UrgeData?> fetch() async {
    final snap = await _doc.get();
    if (!snap.exists || snap.data() == null) return null;
    return UrgeData.fromJson(snap.data()!);
  }
}
