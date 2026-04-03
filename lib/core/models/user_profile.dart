import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
enum SubscriptionStatus {
  @HiveField(0)
  free,
  @HiveField(1)
  trial,
  @HiveField(2)
  premium,
}

@HiveType(typeId: 1)
class UserProfile extends HiveObject {
  UserProfile({
    required this.name,
    required this.quitDate,
    this.quizAnswers = const {},
    this.subscriptionStatus = SubscriptionStatus.free,
  });

  @HiveField(0)
  final String name;

  @HiveField(1)
  final DateTime quitDate;

  /// Maps questionIndex -> selectedOptionIndex.
  @HiveField(2)
  final Map<int, int> quizAnswers;

  @HiveField(3)
  final SubscriptionStatus subscriptionStatus;

  UserProfile copyWith({
    String? name,
    DateTime? quitDate,
    Map<int, int>? quizAnswers,
    SubscriptionStatus? subscriptionStatus,
  }) {
    return UserProfile(
      name: name ?? this.name,
      quitDate: quitDate ?? this.quitDate,
      quizAnswers: quizAnswers ?? this.quizAnswers,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
    );
  }
}
