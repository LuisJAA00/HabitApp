
import 'package:hive/hive.dart';
import 'package:untitled/model/hiveObjects/HabitProgress.dart';
import 'package:untitled/model/hiveObjects/ReminderSettings.dart';


part 'Habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool usesTimer;

  @HiveField(2)
  String frecuency; //veces x semana

  @HiveField(3)
  HabitProgress progress;

  @HiveField(4)
  ReminderSettings? reminder;

  Habit({
    required this.name,
    required this.usesTimer,
    required this.frecuency,
    required this.progress,
    required this.reminder,
  });
}
