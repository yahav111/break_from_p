// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relapse_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RelapseDataAdapter extends TypeAdapter<RelapseData> {
  @override
  final int typeId = 4;

  @override
  RelapseData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RelapseData(
      totalRelapses: fields[0] as int,
      relapseHistory: (fields[1] as List).cast<RelapseEntry>(),
    );
  }

  @override
  void write(BinaryWriter writer, RelapseData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.totalRelapses)
      ..writeByte(1)
      ..write(obj.relapseHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelapseDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
