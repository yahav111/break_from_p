import 'package:hive/hive.dart';

import '../../../core/models/user_profile.dart';
import '../contracts/data_repository.dart';

class HiveUserProfileRepository implements DataRepository<UserProfile> {
  HiveUserProfileRepository(this._box);

  final Box<UserProfile> _box;

  static const _key = 'user_profile';

  @override
  UserProfile? get() => _box.get(_key);

  @override
  Future<void> save(UserProfile profile) => _box.put(_key, profile);

  @override
  Future<void> delete() => _box.delete(_key);
}
