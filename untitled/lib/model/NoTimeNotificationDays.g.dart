// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NoTimeNotificationDays.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoTimeNotificationDaysAdapter
    extends TypeAdapter<NoTimeNotificationDays> {
  @override
  final int typeId = 2;

  @override
  NoTimeNotificationDays read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoTimeNotificationDays(
      days: (fields[0] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, NoTimeNotificationDays obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.days);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoTimeNotificationDaysAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
