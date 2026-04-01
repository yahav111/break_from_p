import 'package:hive/hive.dart';

import '../../core/models/pledge_data.dart';

class PledgeRepository {
  PledgeRepository(this._box);

  final Box<PledgeData> _box;

  static const _key = 'pledge_data';

  PledgeData? get() => _box.get(_key);

  Future<void> save(PledgeData data) => _box.put(_key, data);

  Future<void> delete() => _box.delete(_key);
}
