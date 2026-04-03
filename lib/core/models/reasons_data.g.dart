// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reasons_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReasonsDataAdapter extends TypeAdapter<ReasonsData> {
  @override
  final int typeId = 6;

  @override
  ReasonsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReasonsData(
      reasons: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReasonsData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.reasons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReasonsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
