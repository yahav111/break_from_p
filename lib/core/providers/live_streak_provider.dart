import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'streak_provider.dart';

/// Emits the live duration since quit date every second.
/// Widgets watch this to display real-time streak counters.
final liveStreakProvider = StreamProvider.autoDispose<Duration>((ref) {
  final streakData = ref.watch(streakNotifierProvider);
  if (streakData == null) return Stream.value(Duration.zero);

  final quitDate = streakData.quitDate;
  return Stream.periodic(const Duration(seconds: 1), (_) {
    return DateTime.now().difference(quitDate);
  });
});
