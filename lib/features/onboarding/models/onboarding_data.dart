import 'package:hive/hive.dart';

part 'onboarding_data.g.dart';

@HiveType(typeId: 18)
class OnboardingData extends HiveObject {
  OnboardingData({
    this.gender,
    this.frequencyIndex,
    this.attributionIndex,
    this.escalation,
    this.firstExposureAgeIndex,
    this.arousalDependency,
    this.emotionalCoping,
    this.stressTrigger,
    this.boredomTrigger,
    this.spentMoney,
    this.name,
    this.age,
    this.dependenceScore,
    this.symptoms,
    this.goals,
    this.calculatedQuitDate,
  });

  @HiveField(0)
  final String? gender;

  /// 0=More than once a day, 1=Once a day, 2=Few times/week, 3=Less than once/week
  @HiveField(1)
  final int? frequencyIndex;

  /// 0=Instagram, 1=X, 2=Facebook, 3=TikTok, 4=Google, 5=TV
  @HiveField(2)
  final int? attributionIndex;

  @HiveField(3)
  final bool? escalation;

  /// 0=12 or younger, 1=13-16, 2=17-24, 3=25+
  @HiveField(4)
  final int? firstExposureAgeIndex;

  /// 0=Frequently, 1=Occasionally, 2=Rarely or never
  @HiveField(5)
  final int? arousalDependency;

  @HiveField(6)
  final int? emotionalCoping;

  @HiveField(7)
  final int? stressTrigger;

  @HiveField(8)
  final int? boredomTrigger;

  @HiveField(9)
  final bool? spentMoney;

  @HiveField(10)
  final String? name;

  @HiveField(11)
  final int? age;

  /// Calculated dependence score 0–100.
  @HiveField(12)
  final double? dependenceScore;

  @HiveField(13)
  final List<String>? symptoms;

  @HiveField(14)
  final List<String>? goals;

  @HiveField(15)
  final DateTime? calculatedQuitDate;

  OnboardingData copyWith({
    String? gender,
    int? frequencyIndex,
    int? attributionIndex,
    bool? escalation,
    int? firstExposureAgeIndex,
    int? arousalDependency,
    int? emotionalCoping,
    int? stressTrigger,
    int? boredomTrigger,
    bool? spentMoney,
    String? name,
    int? age,
    double? dependenceScore,
    List<String>? symptoms,
    List<String>? goals,
    DateTime? calculatedQuitDate,
  }) {
    return OnboardingData(
      gender: gender ?? this.gender,
      frequencyIndex: frequencyIndex ?? this.frequencyIndex,
      attributionIndex: attributionIndex ?? this.attributionIndex,
      escalation: escalation ?? this.escalation,
      firstExposureAgeIndex:
          firstExposureAgeIndex ?? this.firstExposureAgeIndex,
      arousalDependency: arousalDependency ?? this.arousalDependency,
      emotionalCoping: emotionalCoping ?? this.emotionalCoping,
      stressTrigger: stressTrigger ?? this.stressTrigger,
      boredomTrigger: boredomTrigger ?? this.boredomTrigger,
      spentMoney: spentMoney ?? this.spentMoney,
      name: name ?? this.name,
      age: age ?? this.age,
      dependenceScore: dependenceScore ?? this.dependenceScore,
      symptoms: symptoms ?? this.symptoms,
      goals: goals ?? this.goals,
      calculatedQuitDate: calculatedQuitDate ?? this.calculatedQuitDate,
    );
  }
}
