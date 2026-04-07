import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/contracts/data_repository.dart';
import '../models/exercise_data.dart';
import '../models/exercise_record.dart';

/// Provided via ProviderScope.overrides at bootstrap.
final exerciseRepositoryProvider =
    Provider<DataRepository<ExerciseData>>((ref) {
  throw UnimplementedError('exerciseRepositoryProvider must be overridden');
});

final exerciseNotifierProvider =
    NotifierProvider<ExerciseNotifier, ExerciseData?>(ExerciseNotifier.new);

class ExerciseNotifier extends Notifier<ExerciseData?> {
  @override
  ExerciseData? build() {
    final repo = ref.read(exerciseRepositoryProvider);
    return repo.get();
  }

  Future<void> recordCompletion({
    required String exerciseType,
    required int durationSeconds,
  }) async {
    final current = state ?? ExerciseData();
    final now = DateTime.now();

    final record = ExerciseRecord(
      id: now.microsecondsSinceEpoch.toString(),
      completedAt: now,
      exerciseType: exerciseType,
      durationSeconds: durationSeconds,
    );

    final updated = ExerciseData(
      records: [record, ...current.records],
      totalCompleted: current.totalCompleted + 1,
    );

    final repo = ref.read(exerciseRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }
}
