// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StreakRecordAdapter extends TypeAdapter<StreakRecord> {
  @override
  final int typeId = 8;

  @override
  StreakRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StreakRecord(
      startDate: fields[0] as DateTime,
      endDate: fields[1] as DateTime,
      days: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StreakRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.startDate)
      ..writeByte(1)
      ..write(obj.endDate)
      ..writeByte(2)
      ..write(obj.days);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
