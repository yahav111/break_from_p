// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 1;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      name: fields[0] as String,
      quitDate: fields[1] as DateTime,
      uid: fields[4] as String?,
      quizAnswers: (fields[2] as Map).cast<int, int>(),
      subscriptionStatus: fields[3] as SubscriptionStatus,
      updatedAt: fields[5] as DateTime?,
      gender: fields[6] as String?,
      age: fields[7] as int?,
      selectedGoals: (fields[8] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quitDate)
      ..writeByte(2)
      ..write(obj.quizAnswers)
      ..writeByte(3)
      ..write(obj.subscriptionStatus)
      ..writeByte(4)
      ..write(obj.uid)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.age)
      ..writeByte(8)
      ..write(obj.selectedGoals);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubscriptionStatusAdapter extends TypeAdapter<SubscriptionStatus> {
  @override
  final int typeId = 0;

  @override
  SubscriptionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubscriptionStatus.free;
      case 1:
        return SubscriptionStatus.trial;
      case 2:
        return SubscriptionStatus.premium;
      default:
        return SubscriptionStatus.free;
    }
  }

  @override
  void write(BinaryWriter writer, SubscriptionStatus obj) {
    switch (obj) {
      case SubscriptionStatus.free:
        writer.writeByte(0);
        break;
      case SubscriptionStatus.trial:
        writer.writeByte(1);
        break;
      case SubscriptionStatus.premium:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      name: json['name'] as String,
      quitDate: DateTime.parse(json['quitDate'] as String),
      uid: json['uid'] as String?,
      quizAnswers: (json['quizAnswers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
          ) ??
          const {},
      subscriptionStatus: $enumDecodeNullable(
              _$SubscriptionStatusEnumMap, json['subscriptionStatus'],
              unknownValue: SubscriptionStatus.free) ??
          SubscriptionStatus.free,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      gender: json['gender'] as String?,
      age: (json['age'] as num?)?.toInt(),
      selectedGoals: (json['selectedGoals'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quitDate': instance.quitDate.toIso8601String(),
      'quizAnswers':
          instance.quizAnswers.map((k, e) => MapEntry(k.toString(), e)),
      'subscriptionStatus':
          _$SubscriptionStatusEnumMap[instance.subscriptionStatus]!,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'gender': instance.gender,
      'age': instance.age,
      'selectedGoals': instance.selectedGoals,
    };

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.free: 'free',
  SubscriptionStatus.trial: 'trial',
  SubscriptionStatus.premium: 'premium',
};
