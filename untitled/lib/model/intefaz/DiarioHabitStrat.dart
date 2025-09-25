import 'package:timezone/timezone.dart' as tz;
import 'package:untitled/services/notiService.dart';


import 'package:untitled/model/hiveObjects/Habit.dart';

import 'package:untitled/model/intefaz/HabitNotificationStrategy.dart';

class DiarioHabitStrat implements HabitNotificationStrategy{
  int hour = 0;
  int minute = 0;


  @override
  Future<void> agendarNotificaciones(Habit habit,DateTime h) async {
    final reminder = habit.reminder;

    if (reminder == null || !reminder.enable) return;

    final now = DateTime.now();

    int timeHour = h.hour;
    int timeMinute = h.minute;

  int idCount = 0;
  for (int i = 0; i < 30; i++) {
    final scheduledDay = now.add(
      Duration(days: i),
    ); //desde el dia de hoy, agregando i dias...

    final scheduledTime = tz.TZDateTime(
        //fehca y hora cuando tendremos alarma
      tz.local,
      scheduledDay.year,
      scheduledDay.month,
      scheduledDay.day,
      //timeHour,
      //timeMinute,
      timeHour,
      timeMinute,
      0,
      );

    if (scheduledTime.isBefore(DateTime.now())) {
      continue;
    }
    final int id = Notiservice.instance.genId(
        habit.key,scheduledTime
      );

    habit.reminder?.notificacioens[scheduledTime] = id;

    await Notiservice.instance.scheduleReminder(
      //realiza la agenda de notificacion.
      id: id, //si el habito tiene id = 1, entonces cada dia seria 11, 12, 13, ... , 17
      title: "${habit.name} $idCount $scheduledTime",
      body: habit.name,
      scheduleTime: scheduledTime,
    );
    idCount++;
    }
  }


  @override
  Future<void> borrarNotificaciones(Habit habit) async {
      
      Map map = habit.reminder!.notificacioens;
      for(DateTime k in map.keys)
      {
        Notiservice.instance.cancelNotification(map[k]);
      }
      map.clear();

      await habit.save();

  }
  


}