import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz_question.dart';

final quizNotifierProvider =
    NotifierProvider<QuizNotifier, QuizState>(QuizNotifier.new);

class QuizState {
  const QuizState({
    this.currentIndex = 0,
    this.answers = const {},
    this.name = '',
    this.quitDate,
  });

  final int currentIndex;

  /// questionIndex -> selectedOptionIndex (for MC questions only).
  final Map<int, int> answers;

  /// Name entered in step 1.
  final String name;

  /// Quit date selected in step 7.
  final DateTime? quitDate;

  int get totalSteps => quizQuestions.length;
  double get progress => (currentIndex + 1) / totalSteps;
  bool get isLastStep => currentIndex >= totalSteps - 1;
  bool get isFirstStep => currentIndex == 0;

  QuizQuestion get currentQuestion => quizQuestions[currentIndex];

  /// Whether the current step has a valid answer.
  bool get canProceed {
    final q = currentQuestion;
    switch (q.stepType) {
      case QuizStepType.textInput:
        return name.trim().isNotEmpty;
      case QuizStepType.multipleChoice:
        // MC questions are skippable, so always allow proceed.
        return true;
      case QuizStepType.datePicker:
        return quitDate != null;
    }
  }

  QuizState copyWith({
    int? currentIndex,
    Map<int, int>? answers,
    String? name,
    DateTime? quitDate,
  }) {
    return QuizState(
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      name: name ?? this.name,
      quitDate: quitDate ?? this.quitDate,
    );
  }
}

class QuizNotifier extends Notifier<QuizState> {
  @override
  QuizState build() => const QuizState();

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void selectAnswer(int optionIndex) {
    final updated = Map<int, int>.from(state.answers);
    updated[state.currentIndex] = optionIndex;
    state = state.copyWith(answers: updated);
  }

  void setQuitDate(DateTime date) {
    state = state.copyWith(quitDate: date);
  }

  void next() {
    if (!state.isLastStep) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previous() {
    if (!state.isFirstStep) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void skip() {
    // Clear any answer for this question, then advance.
    final updated = Map<int, int>.from(state.answers)
      ..remove(state.currentIndex);
    state = state.copyWith(answers: updated);
    next();
  }

  /// Resets quiz state for a fresh start.
  void reset() {
    state = const QuizState();
  }
}
