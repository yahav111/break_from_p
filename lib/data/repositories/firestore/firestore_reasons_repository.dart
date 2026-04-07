import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/reasons_data.dart';
import '../../../infrastructure/firebase/firestore_paths.dart';
import '../contracts/data_repository.dart';

class FirestoreReasonsRepository implements DataRepository<ReasonsData> {
  FirestoreReasonsRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.doc(FirestorePaths.reasonsData(_uid));

  @override
  ReasonsData? get() => null;

  @override
  Future<void> save(ReasonsData data) =>
      _doc.set(data.toJson(), SetOptions(merge: true));

  @override
  Future<void> delete() => _doc.delete();

  Future<ReasonsData?> fetch() async {
    final snap = await _doc.get();
    if (!snap.exists || snap.data() == null) return null;
    return ReasonsData.fromJson(snap.data()!);
  }
}
