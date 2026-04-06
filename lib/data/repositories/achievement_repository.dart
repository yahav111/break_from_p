import 'package:hive/hive.dart';

import '../../core/models/achievement_data.dart';

class AchievementRepository {
  AchievementRepository(this._box);

  final Box<AchievementData> _box;

  static const _key = 'achievement_data';

  AchievementData? get() => _box.get(_key);

  Future<void> save(AchievementData data) => _box.put(_key, data);

  Future<void> delete() => _box.delete(_key);
}
