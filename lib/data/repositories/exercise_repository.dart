import 'package:hive/hive.dart';

import '../../core/models/exercise_data.dart';

class ExerciseRepository {
  ExerciseRepository(this._box);

  final Box<ExerciseData> _box;

  static const _key = 'exercise_data';

  ExerciseData? get() => _box.get(_key);

  Future<void> save(ExerciseData data) => _box.put(_key, data);

  Future<void> delete() => _box.delete(_key);
}
