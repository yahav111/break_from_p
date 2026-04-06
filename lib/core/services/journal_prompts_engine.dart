/// Pure logic for journal prompt sets, including Lifetree-unlockable prompts.
abstract final class JournalPromptsEngine {
  /// Default prompts (always available).
  static const defaultPrompts = [
    'What am I grateful for today?',
    'What triggered me today?',
    'How did I cope with urges?',
    'What progress have I noticed?',
    'What would I tell a friend in my situation?',
    'What are my goals for tomorrow?',
  ];

  /// Deep Reflection prompts (unlocked via Lifetree node 'journal_deep').
  static const deepReflectionPrompts = [
    'What patterns do I notice in my behavior?',
    'What emotion am I avoiding right now?',
    'When I imagine my best self, what does that person look like?',
    'What would I lose if I gave in today?',
    'What have I learned about myself this week?',
  ];

  /// Gratitude prompts (unlocked via Lifetree node 'journal_gratitude').
  static const gratitudePrompts = [
    'What are three things I am grateful for today?',
    'Who has supported me on this journey?',
    'What small victory can I celebrate today?',
    'What part of my recovery am I most proud of?',
    'What good thing happened that I did not expect?',
  ];

  /// Future Self prompts (unlocked via Lifetree node 'journal_future').
  static const futureSelfPrompts = [
    'Dear future me, I want you to know...',
    'In one year, I hope my life looks like...',
    'The person I am becoming would tell me...',
    'What advice would my 90-day self give me today?',
    'What habits am I building now that my future self will thank me for?',
  ];

  /// Node ID → prompt set mapping.
  static const _nodePrompts = <String, List<String>>{
    'journal_deep': deepReflectionPrompts,
    'journal_gratitude': gratitudePrompts,
    'journal_future': futureSelfPrompts,
  };

  /// Returns all prompts available given the unlocked Lifetree node IDs.
  /// Always includes default prompts, plus any unlocked sets.
  static List<String> allUnlockedPrompts(Set<String> unlockedNodeIds) {
    final prompts = [...defaultPrompts];
    for (final entry in _nodePrompts.entries) {
      if (unlockedNodeIds.contains(entry.key)) {
        prompts.addAll(entry.value);
      }
    }
    return prompts;
  }
}
