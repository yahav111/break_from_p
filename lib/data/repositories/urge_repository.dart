import 'package:hive/hive.dart';

import '../../core/models/urge_data.dart';

class UrgeRepository {
  UrgeRepository(this._box);

  final Box<UrgeData> _box;

  static const _key = 'urge_data';

  UrgeData? get() => _box.get(_key);

  Future<void> save(UrgeData data) => _box.put(_key, data);

  Future<void> delete() => _box.delete(_key);
}
