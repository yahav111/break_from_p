// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifetree_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LifetreeDataAdapter extends TypeAdapter<LifetreeData> {
  @override
  final int typeId = 17;

  @override
  LifetreeData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LifetreeData(
      unlockedNodeIds: (fields[0] as List).cast<String>(),
      updatedAt: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LifetreeData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.unlockedNodeIds)
      ..writeByte(1)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LifetreeDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LifetreeData _$LifetreeDataFromJson(Map<String, dynamic> json) => LifetreeData(
      unlockedNodeIds: (json['unlockedNodeIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LifetreeDataToJson(LifetreeData instance) =>
    <String, dynamic>{
      'unlockedNodeIds': instance.unlockedNodeIds,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
