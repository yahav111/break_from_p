import 'package:hive/hive.dart';

import '../../../core/models/streak_data.dart';
import '../contracts/data_repository.dart';

class HiveStreakRepository implements DataRepository<StreakData> {
  HiveStreakRepository(this._box);

  final Box<StreakData> _box;

  static const _key = 'streak_data';

  @override
  StreakData? get() => _box.get(_key);

  @override
  Future<void> save(StreakData data) => _box.put(_key, data);

  @override
  Future<void> delete() => _box.delete(_key);
}
