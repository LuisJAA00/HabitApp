import 'package:untitled/services/notiService.dart';
import 'package:untitled/model/hiveObjects/Habit.dart';
import 'package:untitled/model/hiveObjects/HabitProgress.dart';
import 'package:untitled/model/hiveObjects/ReminderSettings.dart';

class Habitbase {

  Habit habit;
  String get name => habit.name;
  DateTime get lastDateDone => habit.progress.date;
  String get frecuency => habit.frecuency;
  List<int> get daysTodoHabit => habit.progress.daysTodoHabit;
  bool get usesTimer => habit.usesTimer;
  int get key => habit.key;
  int? get timeToCompleteHabit => habit.progress.timeToCompleteHabit;
  ReminderSettings? get reminder => habit.reminder;
  int? get minutesCompleted => habit.progress.minutesCompleted;
  HabitProgress get progress => habit.progress;

  //int get hour => habit.reminder!.time!.hour;
  //int get minute => habit.reminder!.time!.minute;
  //List<int> get notificationList => habit.reminder!.time;
  Habitbase(this.habit);
  Notiservice notificationApi = Notiservice.instance;

}
