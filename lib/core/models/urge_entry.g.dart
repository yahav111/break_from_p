// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'urge_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UrgeEntryAdapter extends TypeAdapter<UrgeEntry> {
  @override
  final int typeId = 11;

  @override
  UrgeEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UrgeEntry(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      intensity: fields[2] as int,
      trigger: fields[3] as String,
      note: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UrgeEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.intensity)
      ..writeByte(3)
      ..write(obj.trigger)
      ..writeByte(4)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UrgeEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UrgeEntry _$UrgeEntryFromJson(Map<String, dynamic> json) => UrgeEntry(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      intensity: (json['intensity'] as num).toInt(),
      trigger: json['trigger'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$UrgeEntryToJson(UrgeEntry instance) => <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'intensity': instance.intensity,
      'trigger': instance.trigger,
      'note': instance.note,
    };
