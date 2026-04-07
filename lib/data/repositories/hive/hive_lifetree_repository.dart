import 'package:hive/hive.dart';

import '../../../core/models/lifetree_data.dart';
import '../contracts/data_repository.dart';

class HiveLifetreeRepository implements DataRepository<LifetreeData> {
  HiveLifetreeRepository(this._box);

  final Box<LifetreeData> _box;

  static const _key = 'lifetree_data';

  @override
  LifetreeData? get() => _box.get(_key);

  @override
  Future<void> save(LifetreeData data) => _box.put(_key, data);

  @override
  Future<void> delete() => _box.delete(_key);
}
