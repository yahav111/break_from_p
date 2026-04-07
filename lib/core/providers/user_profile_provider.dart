import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/contracts/data_repository.dart';
import '../models/user_profile.dart';

/// Provided via ProviderScope.overrides at bootstrap.
final userProfileRepositoryProvider =
    Provider<DataRepository<UserProfile>>((ref) {
  throw UnimplementedError('userProfileRepositoryProvider must be overridden');
});

final userProfileNotifierProvider =
    NotifierProvider<UserProfileNotifier, UserProfile?>(
        UserProfileNotifier.new);

class UserProfileNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() {
    final repo = ref.read(userProfileRepositoryProvider);
    return repo.get();
  }

  Future<void> createProfile({
    required String name,
    required DateTime quitDate,
    Map<int, int> quizAnswers = const {},
  }) async {
    final profile = UserProfile(
      name: name,
      quitDate: quitDate,
      quizAnswers: quizAnswers,
    );
    final repo = ref.read(userProfileRepositoryProvider);
    await repo.save(profile);
    state = profile;
  }

  Future<void> updateProfile(UserProfile profile) async {
    final repo = ref.read(userProfileRepositoryProvider);
    await repo.save(profile);
    state = profile;
  }
}
