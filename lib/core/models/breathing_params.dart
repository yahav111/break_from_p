/// Parameters for a breathing exercise pattern.
///
/// Used to create Lifetree-unlockable breathing variations
/// beyond the default 4-4-4 box breathing.
class BreathingParams {
  const BreathingParams({
    required this.inhale,
    required this.hold,
    required this.exhale,
    required this.cycles,
    required this.label,
  });

  final int inhale;
  final int hold;
  final int exhale;
  final int cycles;
  final String label;

  int get cycleDuration => inhale + hold + exhale;

  double get inhaleEnd => inhale / cycleDuration;
  double get holdEnd => (inhale + hold) / cycleDuration;
}
