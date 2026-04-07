import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/lifetree_data.dart';
import '../../../infrastructure/firebase/firestore_paths.dart';
import '../contracts/data_repository.dart';

class FirestoreLifetreeRepository implements DataRepository<LifetreeData> {
  FirestoreLifetreeRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.doc(FirestorePaths.lifetreeData(_uid));

  @override
  LifetreeData? get() => null;

  @override
  Future<void> save(LifetreeData data) =>
      _doc.set(data.toJson(), SetOptions(merge: true));

  @override
  Future<void> delete() => _doc.delete();

  Future<LifetreeData?> fetch() async {
    final snap = await _doc.get();
    if (!snap.exists || snap.data() == null) return null;
    return LifetreeData.fromJson(snap.data()!);
  }
}
