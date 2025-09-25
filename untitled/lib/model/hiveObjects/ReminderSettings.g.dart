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
      enable: fields[1] as bool,
      pers: fields[2] as bool,
      notificacioens: (fields[0] as Map).cast<DateTime, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReminderSettings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.notificacioens)
      ..writeByte(1)
      ..write(obj.enable)
      ..writeByte(2)
      ..write(obj.pers);
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
