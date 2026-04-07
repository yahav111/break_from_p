// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AchievementEntryAdapter extends TypeAdapter<AchievementEntry> {
  @override
  final int typeId = 15;

  @override
  AchievementEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AchievementEntry(
      id: fields[0] as String,
      unlockedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AchievementEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.unlockedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AchievementEntry _$AchievementEntryFromJson(Map<String, dynamic> json) =>
    AchievementEntry(
      id: json['id'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
    );

Map<String, dynamic> _$AchievementEntryToJson(AchievementEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unlockedAt': instance.unlockedAt.toIso8601String(),
    };
