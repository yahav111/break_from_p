import 'package:hive/hive.dart';

import '../../../core/models/pledge_data.dart';
import '../contracts/data_repository.dart';

class HivePledgeRepository implements DataRepository<PledgeData> {
  HivePledgeRepository(this._box);

  final Box<PledgeData> _box;

  static const _key = 'pledge_data';

  @override
  PledgeData? get() => _box.get(_key);

  @override
  Future<void> save(PledgeData data) => _box.put(_key, data);

  @override
  Future<void> delete() => _box.delete(_key);
}
