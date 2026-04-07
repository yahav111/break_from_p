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
      updatedAt: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UrgeData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.entries)
      ..writeByte(1)
      ..write(obj.totalUrges)
      ..writeByte(2)
      ..write(obj.updatedAt);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UrgeData _$UrgeDataFromJson(Map<String, dynamic> json) => UrgeData(
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => UrgeEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalUrges: (json['totalUrges'] as num?)?.toInt() ?? 0,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UrgeDataToJson(UrgeData instance) => <String, dynamic>{
      'entries': instance.entries.map((e) => e.toJson()).toList(),
      'totalUrges': instance.totalUrges,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
