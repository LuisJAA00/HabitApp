import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'ReminderSettings.g.dart';

@HiveType(typeId: 2)
class ReminderSettings extends HiveObject {
  @HiveField(0)
  String reminderFrec; //daily, specificDays, everyXDays, xPerWeek, xTimesDaily

  @HiveField(2)
  int timesPerWeek; // cuantas veces a la semana se debe recordar, en caso de ser xPerWeek

  @HiveField(4)
  TimeOfDay? time; //null -> no tiempo especifico... // no es la hora del recordatorio, es la hora que el usuario ingresa...

  @HiveField(5)
  bool enable;

  ReminderSettings({
    required this.reminderFrec,

    required this.timesPerWeek,
    required this.time,
    required this.enable,
  });
}
