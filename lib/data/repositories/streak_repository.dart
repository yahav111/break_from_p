import 'package:hive/hive.dart';

import '../../core/models/streak_data.dart';

class StreakRepository {
  StreakRepository(this._box);

  final Box<StreakData> _box;

  static const _key = 'streak_data';

  StreakData? get() => _box.get(_key);

  Future<void> save(StreakData data) => _box.put(_key, data);

  Future<void> delete() => _box.delete(_key);
}
