import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/journal_data.dart';
import '../../../infrastructure/firebase/firestore_paths.dart';
import '../contracts/data_repository.dart';

class FirestoreJournalRepository implements DataRepository<JournalData> {
  FirestoreJournalRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.doc(FirestorePaths.journalData(_uid));

  @override
  JournalData? get() => null;

  @override
  Future<void> save(JournalData data) =>
      _doc.set(data.toJson(), SetOptions(merge: true));

  @override
  Future<void> delete() => _doc.delete();

  Future<JournalData?> fetch() async {
    final snap = await _doc.get();
    if (!snap.exists || snap.data() == null) return null;
    return JournalData.fromJson(snap.data()!);
  }
}
