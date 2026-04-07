import 'package:hive/hive.dart';

import '../../../core/models/notification_preferences.dart';
import '../contracts/data_repository.dart';

class HiveNotificationPreferencesRepository
    implements DataRepository<NotificationPreferences> {
  HiveNotificationPreferencesRepository(this._box);

  final Box<NotificationPreferences> _box;

  static const _key = 'notification_preferences';

  @override
  NotificationPreferences? get() => _box.get(_key);

  @override
  Future<void> save(NotificationPreferences data) => _box.put(_key, data);

  @override
  Future<void> delete() => _box.delete(_key);
}
