/// Milestone data for brain rewire progress.
/// Pure Dart class — no Hive, no Flutter dependency.
class MilestoneInfo {
  const MilestoneInfo({
    required this.days,
    required this.title,
    required this.description,
    required this.scienceMessage,
  });

  final int days;
  final String title;
  final String description;
  final String scienceMessage;
}
