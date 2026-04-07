import 'package:hive/hive.dart';

import '../../../core/models/achievement_data.dart';
import '../contracts/data_repository.dart';

class HiveAchievementRepository implements DataRepository<AchievementData> {
  HiveAchievementRepository(this._box);

  final Box<AchievementData> _box;

  static const _key = 'achievement_data';

  @override
  AchievementData? get() => _box.get(_key);

  @override
  Future<void> save(AchievementData data) => _box.put(_key, data);

  @override
  Future<void> delete() => _box.delete(_key);
}
