
import 'package:timezone/timezone.dart' as tz;
import 'package:untitled/services/notiService.dart';
import 'package:untitled/model/hiveObjects/Habit.dart';
import 'package:untitled/model/intefaz/HabitNotificationStrategy.dart';

class SeleccionadosHabitStrat implements HabitNotificationStrategy{
  @override
  Future<void> agendarNotificaciones(Habit habit,DateTime h) async {
    final reminder = habit.reminder;

    if (!reminder.enable) return;

    final now = DateTime.now();

    int timeHour = h.hour;
    int timeMinute = h.minute;
    
    

    int idCount = 0;
    for (int i = 0; i < 30; i++) {
      final scheduledDay = now.add(Duration(days: i));

      int weekdayIndex = scheduledDay.weekday - 1; // para mapear domingo a 0
      
      if (habit.progress.daysTodoHabit[weekdayIndex] == 1) {
        final scheduledTime = tz.TZDateTime(
          tz.local,
          scheduledDay.year,
          scheduledDay.month,
          scheduledDay.day,
          timeHour,
          timeMinute,
          0,
        );

        if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
          continue;
        }
        int id = Notiservice.instance.genId(habit.key,scheduledTime);
        habit.reminder.notificacioens[scheduledTime] = id;

        await Notiservice.instance.scheduleReminder(
          id: id,
          title: "${habit.name} $idCount $scheduledTime",
          body: habit.name,
          scheduleTime: scheduledTime,
        );
        idCount++;
      }
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
  


  



}