import 'package:hive/hive.dart';

import '../../core/models/relapse_data.dart';

class RelapseRepository {
  RelapseRepository(this._box);

  final Box<RelapseData> _box;

  static const _key = 'relapse_data';

  RelapseData? get() => _box.get(_key);

  Future<void> save(RelapseData data) => _box.put(_key, data);

  Future<void> delete() => _box.delete(_key);
}
