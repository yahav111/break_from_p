import 'package:hive/hive.dart';

import '../../../core/models/reasons_data.dart';
import '../contracts/data_repository.dart';

class HiveReasonsRepository implements DataRepository<ReasonsData> {
  HiveReasonsRepository(this._box);

  final Box<ReasonsData> _box;

  static const _key = 'reasons_data';

  @override
  ReasonsData? get() => _box.get(_key);

  @override
  Future<void> save(ReasonsData data) => _box.put(_key, data);

  @override
  Future<void> delete() => _box.delete(_key);
}
