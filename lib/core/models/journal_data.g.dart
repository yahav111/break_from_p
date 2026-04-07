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
      updatedAt: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, JournalData obj) {
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
      other is JournalDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalData _$JournalDataFromJson(Map<String, dynamic> json) => JournalData(
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => JournalEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$JournalDataToJson(JournalData instance) =>
    <String, dynamic>{
      'entries': instance.entries.map((e) => e.toJson()).toList(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
