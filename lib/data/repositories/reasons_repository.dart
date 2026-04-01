import 'package:hive/hive.dart';

import '../../core/models/reasons_data.dart';

class ReasonsRepository {
  ReasonsRepository(this._box);

  final Box<ReasonsData> _box;

  static const _key = 'reasons_data';

  ReasonsData? get() => _box.get(_key);

  Future<void> save(ReasonsData data) => _box.put(_key, data);

  Future<void> delete() => _box.delete(_key);
}
