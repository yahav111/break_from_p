// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pledge_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PledgeDataAdapter extends TypeAdapter<PledgeData> {
  @override
  final int typeId = 3;

  @override
  PledgeData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PledgeData(
      pledgeDates: (fields[0] as List).cast<DateTime>(),
      currentPledgeStreak: fields[1] as int,
      longestPledgeStreak: fields[2] as int,
      lastPledgeDate: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PledgeData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.pledgeDates)
      ..writeByte(1)
      ..write(obj.currentPledgeStreak)
      ..writeByte(2)
      ..write(obj.longestPledgeStreak)
      ..writeByte(3)
      ..write(obj.lastPledgeDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PledgeDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
