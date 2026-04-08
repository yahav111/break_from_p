/// Pure scoring function that computes a dependence percentage (0–100)
/// from the extended quiz answers.
abstract final class DependenceScoreEngine {
  /// Computes dependence score from quiz answer indices.
  ///
  /// [frequencyIndex] 0-3 (more→less frequent)
  /// [escalation] true/false (yes/no)
  /// [arousalDependency] 0-2 (frequently→rarely)
  /// [emotionalCoping] 0-2
  /// [stressTrigger] 0-2
  /// [boredomTrigger] 0-2
  /// [spentMoney] true/false
  /// [firstExposureAgeIndex] 0-3 (younger→older)
  static double computeScore({
    int? frequencyIndex,
    bool? escalation,
    int? arousalDependency,
    int? emotionalCoping,
    int? stressTrigger,
    int? boredomTrigger,
    bool? spentMoney,
    int? firstExposureAgeIndex,
  }) {
    double score = 0;

    // Frequency: daily=20, once/day=15, few/week=10, rarely=4
    const frequencyScores = [20.0, 15.0, 10.0, 4.0];
    if (frequencyIndex != null && frequencyIndex < frequencyScores.length) {
      score += frequencyScores[frequencyIndex];
    }

    // Escalation: yes=15, no=0
    if (escalation == true) score += 15;

    // Behavioral questions (freq=12, occ=7, rarely=2)
    const behaviorScores = [12.0, 7.0, 2.0];

    for (final answer in [
      arousalDependency,
      emotionalCoping,
      stressTrigger,
      boredomTrigger,
    ]) {
      if (answer != null && answer < behaviorScores.length) {
        score += behaviorScores[answer];
      }
    }

    // Spent money: yes=8, no=0
    if (spentMoney == true) score += 8;

    // First exposure age: 12-=5, 13-16=3, 17-24=1, 25+=0
    const ageScores = [5.0, 3.0, 1.0, 0.0];
    if (firstExposureAgeIndex != null &&
        firstExposureAgeIndex < ageScores.length) {
      score += ageScores[firstExposureAgeIndex];
    }

    // Max possible: 20+15+12*4+8+5 = 96
    // Normalize to percentage, clamped at 100.
    return (score / 96.0 * 100.0).clamp(0, 100);
  }

  /// The fixed "average" comparison value shown in the analysis screen.
  static const double averageScore = 40.0;
}
