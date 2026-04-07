import 'package:hive/hive.dart';

import '../../../core/models/relapse_data.dart';
import '../contracts/data_repository.dart';

class HiveRelapseRepository implements DataRepository<RelapseData> {
  HiveRelapseRepository(this._box);

  final Box<RelapseData> _box;

  static const _key = 'relapse_data';

  @override
  RelapseData? get() => _box.get(_key);

  @override
  Future<void> save(RelapseData data) => _box.put(_key, data);

  @override
  Future<void> delete() => _box.delete(_key);
}
