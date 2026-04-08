import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/extended_quiz_question.dart';

final extendedQuizProvider =
    NotifierProvider<ExtendedQuizNotifier, ExtendedQuizState>(
  ExtendedQuizNotifier.new,
);

class ExtendedQuizState {
  const ExtendedQuizState({
    this.currentIndex = 0,
    this.answers = const {},
    this.name = '',
    this.age,
    this.gender,
  });

  final int currentIndex;

  /// questionIndex → selectedOptionIndex (for MC questions).
  final Map<int, int> answers;
  final String name;
  final int? age;
  final String? gender;

  int get totalSteps => extendedQuizQuestions.length;
  double get progress => (currentIndex + 1) / totalSteps;
  bool get isLastStep => currentIndex >= totalSteps - 1;
  bool get isFirstStep => currentIndex == 0;

  ExtendedQuizQuestion get currentQuestion =>
      extendedQuizQuestions[currentIndex];

  bool get canProceed {
    final q = currentQuestion;
    switch (q.stepType) {
      case ExtendedQuizStepType.multipleChoice:
      case ExtendedQuizStepType.multipleChoiceWithIcons:
        return true; // Always skippable
      case ExtendedQuizStepType.textAndNumberInput:
        return name.trim().isNotEmpty;
    }
  }

  ExtendedQuizState copyWith({
    int? currentIndex,
    Map<int, int>? answers,
    String? name,
    int? age,
    String? gender,
  }) {
    return ExtendedQuizState(
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }
}

class ExtendedQuizNotifier extends Notifier<ExtendedQuizState> {
  @override
  ExtendedQuizState build() => const ExtendedQuizState();

  void selectAnswer(int optionIndex) {
    final updated = Map<int, int>.from(state.answers);
    updated[state.currentIndex] = optionIndex;

    // For Q1 (gender), also store the gender string.
    String? gender = state.gender;
    if (state.currentIndex == 0) {
      gender = extendedQuizQuestions[0].options[optionIndex];
    }

    state = state.copyWith(answers: updated, gender: gender);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setAge(int? age) {
    state = state.copyWith(age: age);
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
    final updated = Map<int, int>.from(state.answers)
      ..remove(state.currentIndex);
    state = state.copyWith(answers: updated);
    next();
  }

  void reset() {
    state = const ExtendedQuizState();
  }
}
