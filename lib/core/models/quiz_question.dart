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
    questionText: 'איך נקרא לך?',
    stepType: QuizStepType.textInput,
    placeholder: 'הכנס את שמך',
  ),
  QuizQuestion(
    questionText: 'באיזו תדירות אתה צופה בפורנוגרפיה?',
    stepType: QuizStepType.multipleChoice,
    options: ['יומי', 'כמה פעמים בשבוע', 'שבועי', 'לעיתים רחוקות'],
    isRequired: false,
  ),
  QuizQuestion(
    questionText: 'כמה זמן אתה מתמודד עם ההרגל הזה?',
    stepType: QuizStepType.multipleChoice,
    options: ['פחות משנה', '1-3 שנים', '3-5 שנים', '5+ שנים'],
    isRequired: false,
  ),
  QuizQuestion(
    questionText: 'שמת לב לשינוי לעבר תוכן קיצוני יותר?',
    stepType: QuizStepType.multipleChoice,
    options: ['כן', 'לא'],
    isRequired: false,
  ),
  QuizQuestion(
    questionText: 'כיצד ההרגל הזה משפיע על חייך היומיומיים?',
    stepType: QuizStepType.multipleChoice,
    options: ['משמעותית', 'במידה מסוימת', 'לא הרבה', 'לא בטוח'],
    isRequired: false,
  ),
  QuizQuestion(
    questionText: 'מהי הסיבה העיקרית שלך לרצות להפסיק?',
    stepType: QuizStepType.multipleChoice,
    options: ['בריאות נפשית', 'יחסים', 'משמעת עצמית', 'פרודוקטיביות'],
    isRequired: false,
  ),
  QuizQuestion(
    questionText: 'מתי תרצה להתחיל את המסע שלך?',
    stepType: QuizStepType.datePicker,
  ),
];
