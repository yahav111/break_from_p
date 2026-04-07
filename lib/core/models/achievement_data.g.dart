// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AchievementDataAdapter extends TypeAdapter<AchievementData> {
  @override
  final int typeId = 16;

  @override
  AchievementData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AchievementData(
      entries: (fields[0] as List).cast<AchievementEntry>(),
      updatedAt: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AchievementData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.entries)
      ..writeByte(1)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AchievementData _$AchievementDataFromJson(Map<String, dynamic> json) =>
    AchievementData(
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => AchievementEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AchievementDataToJson(AchievementData instance) =>
    <String, dynamic>{
      'entries': instance.entries.map((e) => e.toJson()).toList(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
