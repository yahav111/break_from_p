// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StreakDataAdapter extends TypeAdapter<StreakData> {
  @override
  final int typeId = 2;

  @override
  StreakData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StreakData(
      quitDate: fields[0] as DateTime,
      longestStreakDays: fields[1] as int,
      resetHistory: (fields[2] as List).cast<DateTime>(),
      streakHistory: (fields[3] as List).cast<StreakRecord>(),
      updatedAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, StreakData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.quitDate)
      ..writeByte(1)
      ..write(obj.longestStreakDays)
      ..writeByte(2)
      ..write(obj.resetHistory)
      ..writeByte(3)
      ..write(obj.streakHistory)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreakData _$StreakDataFromJson(Map<String, dynamic> json) => StreakData(
      quitDate: DateTime.parse(json['quitDate'] as String),
      longestStreakDays: (json['longestStreakDays'] as num?)?.toInt() ?? 0,
      resetHistory: (json['resetHistory'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const [],
      streakHistory: (json['streakHistory'] as List<dynamic>?)
              ?.map((e) => StreakRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StreakDataToJson(StreakData instance) =>
    <String, dynamic>{
      'quitDate': instance.quitDate.toIso8601String(),
      'longestStreakDays': instance.longestStreakDays,
      'resetHistory':
          instance.resetHistory.map((e) => e.toIso8601String()).toList(),
      'streakHistory': instance.streakHistory.map((e) => e.toJson()).toList(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
