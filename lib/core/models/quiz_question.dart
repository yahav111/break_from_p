/// Defines quiz question types and the static question list.
enum QuizStepType { textInput, multipleChoice, datePicker }

class QuizQuestion {
  const QuizQuestion({
    required this.questionText,
    required this.stepType,
    this.options = const [],
    this.placeholder,
    this.isRequired = true,
  });

  final String questionText;
  final QuizStepType stepType;
  final List<String> options;
  final String? placeholder;
  final bool isRequired;
}

const quizQuestions = <QuizQuestion>[
  QuizQuestion(
    questionText: 'What should we call you?',
    stepType: QuizStepType.textInput,
    placeholder: 'Enter your name',
  ),
  QuizQuestion(
    questionText: 'How often do you watch pornography?',
    stepType: QuizStepType.multipleChoice,
    options: ['Daily', 'Several times a week', 'Weekly', 'Rarely'],
    isRequired: false,
  ),
  QuizQuestion(
    questionText: 'How long have you been struggling with this habit?',
    stepType: QuizStepType.multipleChoice,
    options: ['Less than a year', '1–3 years', '3–5 years', '5+ years'],
    isRequired: false,
  ),
  QuizQuestion(
    questionText: 'Have you noticed a shift towards more extreme material?',
    stepType: QuizStepType.multipleChoice,
    options: ['Yes', 'No'],
    isRequired: false,
  ),
  QuizQuestion(
    questionText: 'How does this habit affect your daily life?',
    stepType: QuizStepType.multipleChoice,
    options: ['Significantly', 'Somewhat', 'Not much', 'Not sure'],
    isRequired: false,
  ),
  QuizQuestion(
    questionText: "What's your main reason for wanting to quit?",
    stepType: QuizStepType.multipleChoice,
    options: ['Mental health', 'Relationships', 'Self-discipline', 'Productivity'],
    isRequired: false,
  ),
  QuizQuestion(
    questionText: 'When do you want to start your journey?',
    stepType: QuizStepType.datePicker,
  ),
];
