import '../models/milestone_info.dart';

/// Pure calculation functions for streak-related logic.
/// No Flutter or storage dependencies — easy to unit test.
abstract final class StreakEngine {
  /// Milestone day markers for brain rewire progress.
  static const milestones = [7, 14, 30, 60, 90];

  /// Number of full days since [quitDate].
  static int daysSince(DateTime quitDate) {
    return DateTime.now().difference(quitDate).inDays;
  }

  /// Returns the larger of the current streak and the previous longest.
  static int longestStreak(int currentDays, int previousLongest) {
    return currentDays > previousLongest ? currentDays : previousLongest;
  }

  /// Brain rewire progress as a 0.0–1.0 fraction (based on 90-day target).
  static double brainRewireProgress(int days) {
    return (days / 90).clamp(0.0, 1.0);
  }

  /// Formats a [Duration] as "Xd Xh Xm Xs".
  static String formatDuration(Duration d) {
    final days = d.inDays;
    final hours = d.inHours.remainder(24);
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  /// Returns [MilestoneInfo] if [days] exactly matches a milestone.
  static MilestoneInfo? checkMilestone(int days) {
    if (!milestones.contains(days)) return null;
    return _milestoneData[days];
  }

  /// Returns the science-based message for a milestone at [days].
  static String milestoneMessage(int days) {
    return _milestoneData[days]?.scienceMessage ?? '';
  }

  /// Returns the highest milestone that has been reached for [days].
  static int? highestMilestoneReached(int days) {
    int? highest;
    for (final m in milestones) {
      if (days >= m) highest = m;
    }
    return highest;
  }

  static const _milestoneData = <int, MilestoneInfo>{
    7: MilestoneInfo(
      days: 7,
      title: 'First Week',
      description: 'You survived the hardest part.',
      scienceMessage:
          'Your brain is beginning to reduce dopamine receptor downregulation. '
          'Withdrawal symptoms like irritability and cravings are at their peak '
          'but will start to ease.',
    ),
    14: MilestoneInfo(
      days: 14,
      title: 'Two Weeks Strong',
      description: 'New neural pathways are forming.',
      scienceMessage:
          'Your prefrontal cortex is regaining control over impulse responses. '
          'Sleep quality and focus are measurably improving as your brain '
          'recalibrates its reward circuitry.',
    ),
    30: MilestoneInfo(
      days: 30,
      title: 'One Month Free',
      description: 'A real habit change is taking hold.',
      scienceMessage:
          'Dopamine receptor density is increasing back toward baseline. '
          'Your brain now finds more pleasure in everyday activities. '
          'Motivation and emotional regulation are noticeably stronger.',
    ),
    60: MilestoneInfo(
      days: 60,
      title: 'Two Months Clean',
      description: 'Your brain is deeply rewiring.',
      scienceMessage:
          'The neural pathways associated with the old habit are weakening '
          'through synaptic pruning. New, healthier patterns are being '
          'reinforced. Confidence and self-control are at their highest.',
    ),
    90: MilestoneInfo(
      days: 90,
      title: 'Brain Rewired',
      description: 'You did it. Your brain has reset.',
      scienceMessage:
          'Research suggests 90 days is the threshold for significant '
          'neuroplastic change. Your dopamine system has largely returned to '
          'baseline. The compulsive pull is replaced by genuine freedom of choice.',
    ),
  };
}
