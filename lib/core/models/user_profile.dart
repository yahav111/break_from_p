import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

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
@JsonSerializable()
class UserProfile extends HiveObject {
  UserProfile({
    required this.name,
    required this.quitDate,
    this.uid,
    this.quizAnswers = const {},
    this.subscriptionStatus = SubscriptionStatus.free,
    this.updatedAt,
  });

  @HiveField(0)
  final String name;

  @HiveField(1)
  final DateTime quitDate;

  /// Maps questionIndex -> selectedOptionIndex.
  @HiveField(2)
  final Map<int, int> quizAnswers;

  @HiveField(3)
  @JsonKey(unknownEnumValue: SubscriptionStatus.free)
  final SubscriptionStatus subscriptionStatus;

  /// Firebase UID — set after authentication.
  @HiveField(4)
  final String? uid;

  /// Last-write-wins timestamp for sync conflict resolution.
  @HiveField(5)
  final DateTime? updatedAt;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? name,
    DateTime? quitDate,
    String? uid,
    Map<int, int>? quizAnswers,
    SubscriptionStatus? subscriptionStatus,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      name: name ?? this.name,
      quitDate: quitDate ?? this.quitDate,
      uid: uid ?? this.uid,
      quizAnswers: quizAnswers ?? this.quizAnswers,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
