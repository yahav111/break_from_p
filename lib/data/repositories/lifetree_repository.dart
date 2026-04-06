import 'package:hive/hive.dart';

import '../../core/models/lifetree_data.dart';

class LifetreeRepository {
  LifetreeRepository(this._box);

  final Box<LifetreeData> _box;

  static const _key = 'lifetree_data';

  LifetreeData? get() => _box.get(_key);

  Future<void> save(LifetreeData data) => _box.put(_key, data);

  Future<void> delete() => _box.delete(_key);
}
