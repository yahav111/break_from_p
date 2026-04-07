import 'package:hive/hive.dart';

import '../../../core/models/urge_data.dart';
import '../contracts/data_repository.dart';

class HiveUrgeRepository implements DataRepository<UrgeData> {
  HiveUrgeRepository(this._box);

  final Box<UrgeData> _box;

  static const _key = 'urge_data';

  @override
  UrgeData? get() => _box.get(_key);

  @override
  Future<void> save(UrgeData data) => _box.put(_key, data);

  @override
  Future<void> delete() => _box.delete(_key);
}
