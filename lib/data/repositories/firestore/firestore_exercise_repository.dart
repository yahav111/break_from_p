import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/exercise_data.dart';
import '../../../infrastructure/firebase/firestore_paths.dart';
import '../contracts/data_repository.dart';

class FirestoreExerciseRepository implements DataRepository<ExerciseData> {
  FirestoreExerciseRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.doc(FirestorePaths.exerciseData(_uid));

  @override
  ExerciseData? get() => null;

  @override
  Future<void> save(ExerciseData data) =>
      _doc.set(data.toJson(), SetOptions(merge: true));

  @override
  Future<void> delete() => _doc.delete();

  Future<ExerciseData?> fetch() async {
    final snap = await _doc.get();
    if (!snap.exists || snap.data() == null) return null;
    return ExerciseData.fromJson(snap.data()!);
  }
}
