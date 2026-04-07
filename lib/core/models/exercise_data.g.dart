// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseDataAdapter extends TypeAdapter<ExerciseData> {
  @override
  final int typeId = 14;

  @override
  ExerciseData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseData(
      records: (fields[0] as List).cast<ExerciseRecord>(),
      totalCompleted: fields[1] as int,
      updatedAt: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.records)
      ..writeByte(1)
      ..write(obj.totalCompleted)
      ..writeByte(2)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseData _$ExerciseDataFromJson(Map<String, dynamic> json) => ExerciseData(
      records: (json['records'] as List<dynamic>?)
              ?.map((e) => ExerciseRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalCompleted: (json['totalCompleted'] as num?)?.toInt() ?? 0,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ExerciseDataToJson(ExerciseData instance) =>
    <String, dynamic>{
      'records': instance.records.map((e) => e.toJson()).toList(),
      'totalCompleted': instance.totalCompleted,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
