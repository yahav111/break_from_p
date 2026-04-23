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

  /// Optional label shown above the question (e.g. "לסיום").
  final String? titleLabel;
}

const extendedQuizQuestions = <ExtendedQuizQuestion>[
  // Q1: Gender
  ExtendedQuizQuestion(
    questionText: 'מה המגדר שלך?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['זכר', 'נקבה'],
  ),

  // Q2: Frequency
  ExtendedQuizQuestion(
    questionText: 'באיזו תדירות אתה צופה בפורנוגרפיה?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: [
      'יותר מפעם ביום',
      'פעם ביום',
      'כמה פעמים בשבוע',
      'פחות מפעם בשבוע',
    ],
  ),

  // Q3: Attribution (with icons)
  ExtendedQuizQuestion(
    questionText: 'איך שמעת עלינו?',
    stepType: ExtendedQuizStepType.multipleChoiceWithIcons,
    options: ['אינסטגרם', 'X', 'פייסבוק', 'טיקטוק', 'גוגל', 'טלוויזיה'],
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
    questionText: 'האם הבחנת במעבר לתוכן קיצוני או גרפי יותר?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['כן', 'לא'],
  ),

  // Q5: First exposure age
  ExtendedQuizQuestion(
    questionText: 'באיזה גיל נחשפת לראשונה לתוכן מיני?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['12 או פחות', '13 עד 16', '17 עד 24', '25 ומעלה'],
  ),

  // Q6: Arousal dependency
  ExtendedQuizQuestion(
    questionText:
        'האם קשה לך להתעורר מינית ללא פורנוגרפיה או פנטזיה?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['לעיתים קרובות', 'לפעמים', 'לעיתים רחוקות או אף פעם'],
  ),

  // Q7: Emotional coping
  ExtendedQuizQuestion(
    questionText:
        'האם אתה משתמש בפורנוגרפיה כדי להתמודד עם מצוקה רגשית או כאב?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['לעיתים קרובות', 'לפעמים', 'לעיתים רחוקות או אף פעם'],
  ),

  // Q8: Stress trigger
  ExtendedQuizQuestion(
    questionText: 'האם אתה פונה לפורנוגרפיה כשאתה בלחץ?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['לעיתים קרובות', 'לפעמים', 'לעיתים רחוקות או אף פעם'],
  ),

  // Q9: Boredom trigger
  ExtendedQuizQuestion(
    questionText: 'האם אתה צופה בפורנוגרפיה משעמום?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['לעיתים קרובות', 'לפעמים', 'לעיתים רחוקות או אף פעם'],
  ),

  // Q10: Spent money
  ExtendedQuizQuestion(
    questionText: 'האם הוצאת כסף על גישה לתוכן מיני?',
    stepType: ExtendedQuizStepType.multipleChoice,
    options: ['כן', 'לא'],
  ),

  // Final: Name & Age
  ExtendedQuizQuestion(
    questionText: 'קצת יותר עליך',
    stepType: ExtendedQuizStepType.textAndNumberInput,
    titleLabel: 'לסיום',
    isSkippable: false,
  ),
];
