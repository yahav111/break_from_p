import 'package:hive/hive.dart';

import '../../../core/models/journal_data.dart';
import '../contracts/data_repository.dart';

class HiveJournalRepository implements DataRepository<JournalData> {
  HiveJournalRepository(this._box);

  final Box<JournalData> _box;

  static const _key = 'journal_data';

  @override
  JournalData? get() => _box.get(_key);

  @override
  Future<void> save(JournalData data) => _box.put(_key, data);

  @override
  Future<void> delete() => _box.delete(_key);
}
