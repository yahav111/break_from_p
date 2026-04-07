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
      updatedAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PledgeData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.pledgeDates)
      ..writeByte(1)
      ..write(obj.currentPledgeStreak)
      ..writeByte(2)
      ..write(obj.longestPledgeStreak)
      ..writeByte(3)
      ..write(obj.lastPledgeDate)
      ..writeByte(4)
      ..write(obj.updatedAt);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PledgeData _$PledgeDataFromJson(Map<String, dynamic> json) => PledgeData(
      pledgeDates: (json['pledgeDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const [],
      currentPledgeStreak: (json['currentPledgeStreak'] as num?)?.toInt() ?? 0,
      longestPledgeStreak: (json['longestPledgeStreak'] as num?)?.toInt() ?? 0,
      lastPledgeDate: json['lastPledgeDate'] == null
          ? null
          : DateTime.parse(json['lastPledgeDate'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PledgeDataToJson(PledgeData instance) =>
    <String, dynamic>{
      'pledgeDates':
          instance.pledgeDates.map((e) => e.toIso8601String()).toList(),
      'currentPledgeStreak': instance.currentPledgeStreak,
      'longestPledgeStreak': instance.longestPledgeStreak,
      'lastPledgeDate': instance.lastPledgeDate?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
