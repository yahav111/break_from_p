import 'package:hive/hive.dart';

import '../../core/models/notification_preferences.dart';

class NotificationPreferencesRepository {
  NotificationPreferencesRepository(this._box);

  final Box<NotificationPreferences> _box;

  static const _key = 'notification_preferences';

  NotificationPreferences? get() => _box.get(_key);

  Future<void> save(NotificationPreferences data) => _box.put(_key, data);

  Future<void> delete() => _box.delete(_key);
}
