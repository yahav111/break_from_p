// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StreakDataAdapter extends TypeAdapter<StreakData> {
  @override
  final int typeId = 2;

  @override
  StreakData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StreakData(
      quitDate: fields[0] as DateTime,
      longestStreakDays: fields[1] as int,
      resetHistory: (fields[2] as List).cast<DateTime>(),
      streakHistory: (fields[3] as List?)?.cast<StreakRecord>() ?? [],
    );
  }

  @override
  void write(BinaryWriter writer, StreakData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.quitDate)
      ..writeByte(1)
      ..write(obj.longestStreakDays)
      ..writeByte(2)
      ..write(obj.resetHistory)
      ..writeByte(3)
      ..write(obj.streakHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
