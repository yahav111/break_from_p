import 'package:hive/hive.dart';

import '../../core/models/user_profile.dart';

class UserProfileRepository {
  UserProfileRepository(this._box);

  final Box<UserProfile> _box;

  static const _key = 'user_profile';

  UserProfile? get() => _box.get(_key);

  Future<void> save(UserProfile profile) => _box.put(_key, profile);

  Future<void> delete() => _box.delete(_key);
}
