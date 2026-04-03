import 'package:hive/hive.dart';

import '../../core/models/journal_data.dart';

class JournalRepository {
  JournalRepository(this._box);

  final Box<JournalData> _box;

  static const _key = 'journal_data';

  JournalData? get() => _box.get(_key);

  Future<void> save(JournalData data) => _box.put(_key, data);

  Future<void> delete() => _box.delete(_key);
}
