// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HabitProgress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitProgressAdapter extends TypeAdapter<HabitProgress> {
  @override
  final int typeId = 1;

  @override
  HabitProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitProgress(
      date: fields[0] as DateTime,
      vecesCompletado: fields[1] as int,
      isActive: fields[2] as bool,
      startedAt: fields[3] as DateTime?,
      numeroVecesSemana: fields[4] as int,
      daysOfWeekCompleted: (fields[5] as List).cast<int>(),
      timeToCompleteHabit: fields[8] as int?,
      daysTodoHabit: (fields[6] as List).cast<int>(),
      totalCompletions: fields[7] as int,
      minutesCompleted: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HabitProgress obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.vecesCompletado)
      ..writeByte(2)
      ..write(obj.isActive)
      ..writeByte(3)
      ..write(obj.startedAt)
      ..writeByte(4)
      ..write(obj.numeroVecesSemana)
      ..writeByte(5)
      ..write(obj.daysOfWeekCompleted)
      ..writeByte(6)
      ..write(obj.daysTodoHabit)
      ..writeByte(7)
      ..write(obj.totalCompletions)
      ..writeByte(8)
      ..write(obj.timeToCompleteHabit)
      ..writeByte(9)
      ..write(obj.minutesCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
