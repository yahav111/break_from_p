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
    );
  }

  @override
  void write(BinaryWriter writer, AchievementData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.entries);
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
