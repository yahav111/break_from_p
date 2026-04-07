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
      updatedAt: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RelapseData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.totalRelapses)
      ..writeByte(1)
      ..write(obj.relapseHistory)
      ..writeByte(2)
      ..write(obj.updatedAt);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelapseData _$RelapseDataFromJson(Map<String, dynamic> json) => RelapseData(
      totalRelapses: (json['totalRelapses'] as num?)?.toInt() ?? 0,
      relapseHistory: (json['relapseHistory'] as List<dynamic>?)
              ?.map((e) => RelapseEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RelapseDataToJson(RelapseData instance) =>
    <String, dynamic>{
      'totalRelapses': instance.totalRelapses,
      'relapseHistory': instance.relapseHistory.map((e) => e.toJson()).toList(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
