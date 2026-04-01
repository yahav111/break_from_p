import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quitter/core/models/quiz_question.dart';
import 'package:quitter/core/providers/quiz_provider.dart';

void main() {
  group('QuizNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state', () {
      final state = container.read(quizNotifierProvider);
      expect(state.currentIndex, 0);
      expect(state.answers, isEmpty);
      expect(state.name, '');
      expect(state.quitDate, isNull);
      expect(state.isFirstStep, true);
      expect(state.totalSteps, quizQuestions.length);
    });

    test('setName updates name', () {
      container.read(quizNotifierProvider.notifier).setName('Alex');
      expect(container.read(quizNotifierProvider).name, 'Alex');
    });

    test('next advances currentIndex', () {
      container.read(quizNotifierProvider.notifier).next();
      expect(container.read(quizNotifierProvider).currentIndex, 1);
    });

    test('previous decrements currentIndex', () {
      container.read(quizNotifierProvider.notifier).next();
      container.read(quizNotifierProvider.notifier).next();
      container.read(quizNotifierProvider.notifier).previous();
      expect(container.read(quizNotifierProvider).currentIndex, 1);
    });

    test('previous does not go below 0', () {
      container.read(quizNotifierProvider.notifier).previous();
      expect(container.read(quizNotifierProvider).currentIndex, 0);
    });

    test('next does not exceed last step', () {
      final notifier = container.read(quizNotifierProvider.notifier);
      for (int i = 0; i < quizQuestions.length + 5; i++) {
        notifier.next();
      }
      expect(
        container.read(quizNotifierProvider).currentIndex,
        quizQuestions.length - 1,
      );
    });

    test('selectAnswer records answer', () {
      container.read(quizNotifierProvider.notifier).next(); // go to MC step
      container.read(quizNotifierProvider.notifier).selectAnswer(2);
      final state = container.read(quizNotifierProvider);
      expect(state.answers[1], 2);
    });

    test('setQuitDate updates quitDate', () {
      final date = DateTime(2026, 4, 1);
      container.read(quizNotifierProvider.notifier).setQuitDate(date);
      expect(container.read(quizNotifierProvider).quitDate, date);
    });

    test('skip advances without recording answer', () {
      container.read(quizNotifierProvider.notifier).next(); // step 1
      container.read(quizNotifierProvider.notifier).selectAnswer(1);
      container.read(quizNotifierProvider.notifier).skip();
      final state = container.read(quizNotifierProvider);
      expect(state.answers.containsKey(1), false);
      expect(state.currentIndex, 2);
    });

    test('reset clears all state', () {
      final notifier = container.read(quizNotifierProvider.notifier);
      notifier.setName('Test');
      notifier.next();
      notifier.selectAnswer(0);
      notifier.reset();
      final state = container.read(quizNotifierProvider);
      expect(state.currentIndex, 0);
      expect(state.name, '');
      expect(state.answers, isEmpty);
    });

    test('progress calculation', () {
      final state = container.read(quizNotifierProvider);
      expect(state.progress, 1 / quizQuestions.length);

      container.read(quizNotifierProvider.notifier).next();
      final nextState = container.read(quizNotifierProvider);
      expect(nextState.progress, 2 / quizQuestions.length);
    });

    test('canProceed for text input', () {
      // Step 0 is text input (name)
      expect(container.read(quizNotifierProvider).canProceed, false);

      container.read(quizNotifierProvider.notifier).setName('Alex');
      expect(container.read(quizNotifierProvider).canProceed, true);
    });

    test('canProceed for MC is always true (skippable)', () {
      container.read(quizNotifierProvider.notifier).next(); // step 1 = MC
      expect(container.read(quizNotifierProvider).canProceed, true);
    });
  });
}
