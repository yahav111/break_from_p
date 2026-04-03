// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'urge_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UrgeDataAdapter extends TypeAdapter<UrgeData> {
  @override
  final int typeId = 12;

  @override
  UrgeData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UrgeData(
      entries: (fields[0] as List).cast<UrgeEntry>(),
      totalUrges: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UrgeData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.entries)
      ..writeByte(1)
      ..write(obj.totalUrges);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UrgeDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
