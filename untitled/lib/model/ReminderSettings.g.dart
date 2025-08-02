// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReminderSettings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderSettingsAdapter extends TypeAdapter<ReminderSettings> {
  @override
  final int typeId = 2;

  @override
  ReminderSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderSettings(
      reminderFrec: fields[0] as String,
      timesPerWeek: fields[2] as int,
      time: fields[4] as TimeOfDay?,
      enable: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.reminderFrec)
      ..writeByte(2)
      ..write(obj.timesPerWeek)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.enable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
