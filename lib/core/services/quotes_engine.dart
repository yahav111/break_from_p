/// Curated motivational quotes rotated daily.
abstract final class QuotesEngine {
  static const _quotes = <({String text, String? author})>[
    (text: 'סוד השינוי הוא למקד את כל האנרגיה שלך לא במאבק בישן, אלא בבניית החדש.', author: 'Socrates'),
    (text: 'כל יום הוא הזדמנות חדשה לשנות את חייך.', author: null),
    (text: 'לא משנה כמה לאט אתה הולך, כל עוד אתה לא עוצר.', author: 'Confucius'),
    (text: 'תיפול שבע פעמים, תקום שמונה.', author: 'Japanese Proverb'),
    (text: 'האדם היחיד שאתה מיועד להיות הוא האדם שאתה מחליט להיות.', author: 'Ralph Waldo Emerson'),
    (text: 'הכוח לא מגיע מניצחון. המאבקים שלך הם אלו שבונים את הכוח שלך.', author: 'Arnold Schwarzenegger'),
    (text: 'אתה אמיץ יותר ממה שאתה מאמין, חזק יותר ממה שאתה נראה, וחכם יותר ממה שאתה חושב.', author: 'A.A. Milne'),
    (text: 'החלמה היא לא מרוץ. אתה לא צריך להרגיש אשם אם זה לוקח לך יותר זמן ממה שחשבת.', author: null),
    (text: 'מה שנמצא מאחורינו ומה שנמצא לפנינו הם דברים זניחים בהשוואה למה שבתוכנו.', author: 'Ralph Waldo Emerson'),
    (text: 'הזמן הטוב ביותר לשתול עץ היה לפני עשרים שנה. הזמן השני הכי טוב הוא עכשיו.', author: 'Chinese Proverb'),
    (text: 'אומץ הוא לא היעדר פחד, אלא הניצחון עליו.', author: 'Nelson Mandela'),
    (text: 'יום אחד בכל פעם. זה כל מה שאנחנו יכולים לבקש מעצמנו.', author: null),
    (text: 'הנסיבות הנוכחיות שלך לא קובעות לאן אתה יכול להגיע; הן רק קובעות מאיפה אתה מתחיל.', author: 'Nido Qubein'),
    (text: 'התהילה הגדולה ביותר בחיים היא לא לא ליפול אף פעם, אלא לקום בכל פעם שנופלים.', author: 'Nelson Mandela'),
    (text: 'תאמין שאתה יכול, וכבר עברת חצי דרך.', author: 'Theodore Roosevelt'),
    (text: 'חופש הוא מה שאתה עושה עם מה שעשו לך.', author: 'Jean-Paul Sartre'),
    (text: 'אתה לא חייב להיות מושלם כדי להיות מדהים.', author: null),
    (text: 'המסע היחיד שהוא בלתי אפשרי הוא זה שלעולם לא התחלת.', author: 'Tony Robbins'),
    (text: 'החלמה היא לא קו ישר. תהיה סבלני עם עצמך.', author: null),
    (text: 'תתחיל מאיפה שאתה. תשתמש במה שיש לך. תעשה מה שאתה יכול.', author: 'Arthur Ashe'),
    (text: 'באמצע הקושי טמונה ההזדמנות.', author: 'Albert Einstein'),
    (text: 'אתה לא ההרגלים שלך. אתה זה שיכול לשנות אותם.', author: null),
    (text: 'זה תמיד נראה בלתי אפשרי עד שזה נעשה.', author: 'Nelson Mandela'),
    (text: 'הצלחה היא סך כל המאמצים הקטנים, שחוזרים על עצמם יום אחר יום.', author: 'Robert Collier'),
    (text: 'הכאב שאתה מרגיש היום יהיה הכוח שתרגיש מחר.', author: null),
    (text: 'מסע של אלף מילין מתחיל בצעד אחד.', author: 'Lao Tzu'),
    (text: 'אנחנו מה שאנחנו עושים שוב ושוב. מצוינות, אם כן, אינה מעשה אלא הרגל.', author: 'Aristotle'),
    (text: 'אל תספור את הימים. תגרום לימים לספור.', author: 'Muhammad Ali'),
    (text: 'העצמי העתידי שלך יודה לך על המאמץ שאתה משקיע היום.', author: null),
    (text: 'משמעת עצמית היא אהבה עצמית.', author: null),
    (text: 'כל רגע הוא התחלה חדשה.', author: 'T.S. Eliot'),
    (text: 'התקדמות, לא שלמות.', author: null),
    (text: 'האדם שמזיז הר מתחיל בלסלק אבנים קטנות.', author: 'Confucius'),
    (text: 'מותר לך להיות גם יצירת מופת וגם עבודה בתהליך בו זמנית.', author: 'Sophia Bush'),
    (text: 'משמעת היא הבחירה בין מה שאתה רוצה עכשיו לבין מה שאתה הכי רוצה.', author: 'Abraham Lincoln'),
    (text: 'תהיה חזק יותר מהתירוץ החזק ביותר שלך.', author: null),
    (text: 'החיים שלך לא משתפרים במקרה. הם משתפרים בשינוי.', author: 'Jim Rohn'),
    (text: 'צמיחה כואבת. שינוי כואב. אבל שום דבר לא כואב כמו להישאר תקוע.', author: null),
    (text: 'הפוך את הפצעים שלך לחוכמה.', author: 'Oprah Winfrey'),
    (text: 'הקאמבק תמיד חזק יותר מהנפילה.', author: null),
  ];

  /// Returns the quote text for a given day of the year (1-366).
  static String quoteForDay(int dayOfYear) {
    return _quotes[dayOfYear % _quotes.length].text;
  }

  /// Returns the author attribution for the quote, or null if anonymous.
  static String? authorForDay(int dayOfYear) {
    return _quotes[dayOfYear % _quotes.length].author;
  }
}
