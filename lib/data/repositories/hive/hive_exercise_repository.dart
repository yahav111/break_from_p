import 'package:hive/hive.dart';

import '../../../core/models/exercise_data.dart';
import '../contracts/data_repository.dart';

class HiveExerciseRepository implements DataRepository<ExerciseData> {
  HiveExerciseRepository(this._box);

  final Box<ExerciseData> _box;

  static const _key = 'exercise_data';

  @override
  ExerciseData? get() => _box.get(_key);

  @override
  Future<void> save(ExerciseData data) => _box.put(_key, data);

  @override
  Future<void> delete() => _box.delete(_key);
}
