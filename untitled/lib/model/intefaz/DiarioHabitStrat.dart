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

    if (!reminder.enable) return;

    final now = DateTime.now();

    int timeHour = h.hour;
    int timeMinute = h.minute;
    print("hora");
    print(timeHour);
    print("minuto");
    print(timeMinute);

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
      timeHour,
      timeMinute,
      0,
      );

    if (scheduledTime.isBefore(DateTime.now())) {
      print("rejected" + DateTime.now().toString());
      print("against" + scheduledTime.toString());
      continue;
    }
    final int id = Notiservice.instance.genId(
        habit.key,scheduledTime
      );

    habit.reminder.notificacioens[scheduledTime] = id;

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
      
      Map map = habit.reminder.notificacioens;
      for(DateTime k in map.keys)
      {
        Notiservice.instance.cancelNotification(map[k]);
      }
      map.clear();

      await habit.save();

  }
  
  /*
  @override
  Future<void> reAgendarNotificaciones(Habit habit, DateTime h, DateTime start ) async{
    final reminder = habit.reminder;

    if (!reminder.enable) return;

    // la ultima notificacion registrada, el ultimo habito sonará en la fecha "start"
    final now = start.add(Duration(days: 1)); //como es diario, el siguiente sonará en start+1 dia...

    int timeHour = h.hour; //hora y minuto del habito
    int timeMinute = h.minute;
    print("hora");
    print(timeHour);
    print("minuto");
    print(timeMinute);

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
      timeHour,
      timeMinute,
      0,
      );

    if (scheduledTime.isBefore(DateTime.now())) {
      print("rejected" + DateTime.now().toString());
      print("against" + scheduledTime.toString());
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
  */
  


}