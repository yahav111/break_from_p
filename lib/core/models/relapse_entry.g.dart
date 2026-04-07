// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relapse_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RelapseEntryAdapter extends TypeAdapter<RelapseEntry> {
  @override
  final int typeId = 5;

  @override
  RelapseEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RelapseEntry(
      date: fields[0] as DateTime,
      reason: fields[1] as String?,
      streakDaysLost: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RelapseEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.reason)
      ..writeByte(2)
      ..write(obj.streakDaysLost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelapseEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelapseEntry _$RelapseEntryFromJson(Map<String, dynamic> json) => RelapseEntry(
      date: DateTime.parse(json['date'] as String),
      reason: json['reason'] as String?,
      streakDaysLost: (json['streakDaysLost'] as num).toInt(),
    );

Map<String, dynamic> _$RelapseEntryToJson(RelapseEntry instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'reason': instance.reason,
      'streakDaysLost': instance.streakDaysLost,
    };
