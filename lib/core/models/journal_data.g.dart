// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JournalDataAdapter extends TypeAdapter<JournalData> {
  @override
  final int typeId = 10;

  @override
  JournalData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalData(
      entries: (fields[0] as List).cast<JournalEntry>(),
    );
  }

  @override
  void write(BinaryWriter writer, JournalData obj) {
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
      other is JournalDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
