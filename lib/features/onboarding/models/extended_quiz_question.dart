import 'package:flutter/material.dart';

enum ExtendedQuizStepType {
  multipleChoice,
  multipleChoiceWithIcons,
  textAndNumberInput,
}

class ExtendedQuizQuestion {
  const ExtendedQuizQuestion({
    required this.questionText,
    required this.stepType,
    this.options = const [],
    this.optionIcons = const [],
    this.isSkippable = true,
    this.titleLabel,
  });

  final String questionText;
  final ExtendedQuizStepType stepType;
  final List<String> options;

  /// Icons for multipleChoiceWithIcons step type.
  final List<IconData> optionIcons;
  final bool isSkippable;

  /// Optional label shown above the question (e.g. "Finally").
  final String? titleLabel;
}

const extendedQuizQuestions = <ExtendedQuizQuestion>[
  // Q1: Gender
  ExtendedQuizQuestion(
    questionText: 'What is your gender?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['Male', 'Female'],
  ),

  // Q2: Frequency
  ExtendedQuizQuestion(
    questionText: 'How often do you typically view pornography?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: [
      'More than once a day',
      'Once a day',
      'A few times a week',
      'Less than once a week',
    ],
  ),

  // Q3: Attribution (with icons)
  ExtendedQuizQuestion(
    questionText: 'Where did you hear about us?',
    stepType: ExtendedQuizStepType.multipleChoiceWithIcons,
    options: ['Instagram', 'X', 'Facebook', 'TikTok', 'Google', 'TV'],
    optionIcons: [
      Icons.camera_alt_rounded,
      Icons.close_rounded,
      Icons.facebook_rounded,
      Icons.music_note_rounded,
      Icons.search_rounded,
      Icons.tv_rounded,
    ],
  ),

  // Q4: Escalation
  ExtendedQuizQuestion(
    questionText:
        'Have you noticed a shift towards more extreme or graphic material?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['Yes', 'No'],
  ),

  // Q5: First exposure age
  ExtendedQuizQuestion(
    questionText:
        'At what age did you first come across explicit content?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['12 or younger', '13 to 16', '17 to 24', '25 or older'],
  ),

  // Q6: Arousal dependency
  ExtendedQuizQuestion(
    questionText:
        'Do you find it difficult to achieve sexual arousal without pornography or fantasy?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['Frequently', 'Occasionally', 'Rarely or never'],
  ),

  // Q7: Emotional coping
  ExtendedQuizQuestion(
    questionText:
        'Do you use pornography as a way to cope with emotional discomfort or pain?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['Frequently', 'Occasionally', 'Rarely or never'],
  ),

  // Q8: Stress trigger
  ExtendedQuizQuestion(
    questionText: 'Do you turn to pornography when feeling stressed?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['Frequently', 'Occasionally', 'Rarely or never'],
  ),

  // Q9: Boredom trigger
  ExtendedQuizQuestion(
    questionText: 'Do you watch pornography out of boredom?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['Frequently', 'Occasionally', 'Rarely or never'],
  ),

  // Q10: Spent money
  ExtendedQuizQuestion(
    questionText:
        'Have you ever spent money on accessing explicit content?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['Yes', 'No'],
  ),

  // Final: Name & Age
  ExtendedQuizQuestion(
    questionText: 'A little more about you',
    stepType: ExtendedQuizStepType.textAndNumberInput,
    titleLabel: 'Finally',
    isSkippable: false,
  ),
];
