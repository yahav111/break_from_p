/// Curated motivational quotes rotated daily.
abstract final class QuotesEngine {
  static const _quotes = <({String text, String? author})>[
    (text: 'The secret of change is to focus all of your energy not on fighting the old, but on building the new.', author: 'Socrates'),
    (text: 'Every day is a new opportunity to change your life.', author: null),
    (text: 'It does not matter how slowly you go as long as you do not stop.', author: 'Confucius'),
    (text: 'Fall seven times, stand up eight.', author: 'Japanese Proverb'),
    (text: 'The only person you are destined to become is the person you decide to be.', author: 'Ralph Waldo Emerson'),
    (text: 'Strength does not come from winning. Your struggles develop your strengths.', author: 'Arnold Schwarzenegger'),
    (text: 'You are braver than you believe, stronger than you seem, and smarter than you think.', author: 'A.A. Milne'),
    (text: 'Recovery is not a race. You don\'t have to feel guilty if it takes you longer than you thought it would.', author: null),
    (text: 'What lies behind us and what lies before us are tiny matters compared to what lies within us.', author: 'Ralph Waldo Emerson'),
    (text: 'The best time to plant a tree was 20 years ago. The second best time is now.', author: 'Chinese Proverb'),
    (text: 'Courage is not the absence of fear, but the triumph over it.', author: 'Nelson Mandela'),
    (text: 'One day at a time. That\'s all we can ask of ourselves.', author: null),
    (text: 'Your present circumstances don\'t determine where you can go; they merely determine where you start.', author: 'Nido Qubein'),
    (text: 'The greatest glory in living lies not in never falling, but in rising every time we fall.', author: 'Nelson Mandela'),
    (text: 'Believe you can and you\'re halfway there.', author: 'Theodore Roosevelt'),
    (text: 'Freedom is what you do with what\'s been done to you.', author: 'Jean-Paul Sartre'),
    (text: 'You don\'t have to be perfect to be amazing.', author: null),
    (text: 'The only impossible journey is the one you never begin.', author: 'Tony Robbins'),
    (text: 'Healing is not linear. Be patient with yourself.', author: null),
    (text: 'Start where you are. Use what you have. Do what you can.', author: 'Arthur Ashe'),
    (text: 'In the middle of difficulty lies opportunity.', author: 'Albert Einstein'),
    (text: 'You are not your habits. You are the one who can change them.', author: null),
    (text: 'It always seems impossible until it\'s done.', author: 'Nelson Mandela'),
    (text: 'Success is the sum of small efforts, repeated day in and day out.', author: 'Robert Collier'),
    (text: 'The pain you feel today will be the strength you feel tomorrow.', author: null),
    (text: 'A journey of a thousand miles begins with a single step.', author: 'Lao Tzu'),
    (text: 'We are what we repeatedly do. Excellence, then, is not an act, but a habit.', author: 'Aristotle'),
    (text: 'Don\'t count the days. Make the days count.', author: 'Muhammad Ali'),
    (text: 'Your future self will thank you for the effort you put in today.', author: null),
    (text: 'Self-discipline is self-love.', author: null),
    (text: 'Every moment is a fresh beginning.', author: 'T.S. Eliot'),
    (text: 'Progress, not perfection.', author: null),
    (text: 'The man who moves a mountain begins by carrying away small stones.', author: 'Confucius'),
    (text: 'You are allowed to be both a masterpiece and a work in progress simultaneously.', author: 'Sophia Bush'),
    (text: 'Discipline is choosing between what you want now and what you want most.', author: 'Abraham Lincoln'),
    (text: 'Be stronger than your strongest excuse.', author: null),
    (text: 'Your life does not get better by chance. It gets better by change.', author: 'Jim Rohn'),
    (text: 'Growth is painful. Change is painful. But nothing is as painful as staying stuck.', author: null),
    (text: 'Turn your wounds into wisdom.', author: 'Oprah Winfrey'),
    (text: 'The comeback is always stronger than the setback.', author: null),
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
