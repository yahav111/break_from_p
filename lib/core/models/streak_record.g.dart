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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreakRecord _$StreakRecordFromJson(Map<String, dynamic> json) => StreakRecord(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      days: (json['days'] as num).toInt(),
    );

Map<String, dynamic> _$StreakRecordToJson(StreakRecord instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'days': instance.days,
    };
