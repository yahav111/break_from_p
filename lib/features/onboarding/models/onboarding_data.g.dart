// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OnboardingDataAdapter extends TypeAdapter<OnboardingData> {
  @override
  final int typeId = 18;

  @override
  OnboardingData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnboardingData(
      gender: fields[0] as String?,
      frequencyIndex: fields[1] as int?,
      attributionIndex: fields[2] as int?,
      escalation: fields[3] as bool?,
      firstExposureAgeIndex: fields[4] as int?,
      arousalDependency: fields[5] as int?,
      emotionalCoping: fields[6] as int?,
      stressTrigger: fields[7] as int?,
      boredomTrigger: fields[8] as int?,
      spentMoney: fields[9] as bool?,
      name: fields[10] as String?,
      age: fields[11] as int?,
      dependenceScore: fields[12] as double?,
      symptoms: (fields[13] as List?)?.cast<String>(),
      goals: (fields[14] as List?)?.cast<String>(),
      calculatedQuitDate: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OnboardingData obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.gender)
      ..writeByte(1)
      ..write(obj.frequencyIndex)
      ..writeByte(2)
      ..write(obj.attributionIndex)
      ..writeByte(3)
      ..write(obj.escalation)
      ..writeByte(4)
      ..write(obj.firstExposureAgeIndex)
      ..writeByte(5)
      ..write(obj.arousalDependency)
      ..writeByte(6)
      ..write(obj.emotionalCoping)
      ..writeByte(7)
      ..write(obj.stressTrigger)
      ..writeByte(8)
      ..write(obj.boredomTrigger)
      ..writeByte(9)
      ..write(obj.spentMoney)
      ..writeByte(10)
      ..write(obj.name)
      ..writeByte(11)
      ..write(obj.age)
      ..writeByte(12)
      ..write(obj.dependenceScore)
      ..writeByte(13)
      ..write(obj.symptoms)
      ..writeByte(14)
      ..write(obj.goals)
      ..writeByte(15)
      ..write(obj.calculatedQuitDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
