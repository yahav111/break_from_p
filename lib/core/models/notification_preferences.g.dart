// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationPreferencesAdapter
    extends TypeAdapter<NotificationPreferences> {
  @override
  final int typeId = 7;

  @override
  NotificationPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationPreferences(
      morningPledgeEnabled: fields[0] as bool,
      morningPledgeHour: fields[1] as int,
      morningPledgeMinute: fields[2] as int,
      milestoneEnabled: fields[3] as bool,
      dailyMotivationEnabled: fields[4] as bool,
      eveningCheckInEnabled: fields[5] as bool,
      eveningCheckInHour: fields[6] as int,
      eveningCheckInMinute: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationPreferences obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.morningPledgeEnabled)
      ..writeByte(1)
      ..write(obj.morningPledgeHour)
      ..writeByte(2)
      ..write(obj.morningPledgeMinute)
      ..writeByte(3)
      ..write(obj.milestoneEnabled)
      ..writeByte(4)
      ..write(obj.dailyMotivationEnabled)
      ..writeByte(5)
      ..write(obj.eveningCheckInEnabled)
      ..writeByte(6)
      ..write(obj.eveningCheckInHour)
      ..writeByte(7)
      ..write(obj.eveningCheckInMinute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
