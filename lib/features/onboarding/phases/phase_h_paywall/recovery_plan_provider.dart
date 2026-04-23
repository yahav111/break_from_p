import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../phase_b_quiz/extended_quiz_provider.dart';
import 'models/recovery_plan.dart';
import 'recovery_plan_engine.dart';

/// Holds the user's selected goals in-memory while onboarding is in progress.
/// Persisted to [UserProfile] via `createProfile` at the end of the flow.
final selectedGoalsProvider = StateProvider<List<String>>((_) => const []);

/// Rebuilds whenever quiz answers, name, or selected goals change.
final recoveryPlanProvider = Provider<RecoveryPlan>((ref) {
  final quiz = ref.watch(extendedQuizProvider);
  final goals = ref.watch(selectedGoalsProvider);
  return RecoveryPlanEngine.build(
    answers: quiz.answers,
    goals: goals,
    userName: quiz.name.isEmpty ? null : quiz.name,
  );
});
