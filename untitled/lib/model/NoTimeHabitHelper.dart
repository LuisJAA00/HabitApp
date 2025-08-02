
import 'package:rxdart/streams.dart';
import 'package:untitled/componentes/notificationsApi.dart';

import 'package:untitled/model/Habit.dart';
import 'package:untitled/model/HabitService.dart';
import 'DBHelper.dart';


class NoTimeHabitHelper  {

  final NotificationApi _notifications = NotificationApi.instance;
 
  DBHelper db = DBHelper.instance;

  

  bool _pendingHabitsToday(DateTime day, Habit h)
  { //true : habito tiene notificacion hoy
    final today = _stripTime(day);
    final started = _stripTime(h.progress.startedAt!);

    final int diff = today.difference(started).inDays;
    switch (h.frecuency)
    {
      case 'diario':
        if(30 - diff > 0 )
        {
          return true;
        }
        break;
      case 'xPorSemana':
          //
        break;
      case 'diasEspecificos':
        final int weekday = DateTime.now().weekday-1;
        if(30 - diff > 0  && h.progress.daysTodoHabit[weekday] == 1)
        {
          return true;
        }
        break;
    }
    
    return false;
  }

  DateTime _stripTime(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
}


  void updateNotificationsDaily(Habit h)
  {
    //todos los habitos de este tipo tienen el mismo id...
    //si se escribe en la misma hora y fecha, se sobreescribe si el id es el mismo...
    programarRecordatoriosHabitos(h);
    
  }
  

  void deleteNotifications(Habit habit,when)
  {
    print("checando eliminacion dia...");
    for(final h in db.habitBox.values)
    {
      if(h.reminder?.time != null) continue;
      if(_pendingHabitsToday(when, h) && habit.key != h.key || !_pendingHabitsToday(when, h)) //o si este mismo tampoco tiene para tal dia...
      {
        print("habito tiene notificacion para hoy...");
        return;
      }
    }
    print("cancelando");
    final cancelDate1 = DateTime(
      when.year,
      when.month,
      when.day,
      18,
      00,
    );
    final cancelDate2 = DateTime(
      when.year,
      when.month,
      when.day,
      11,
      00,
    );
    _notifications.cancelSingleNot(habit, cancelDate1);
    _notifications.cancelSingleNot(habit, cancelDate2);
    
  }
  void deleteNotificationNext(Habit habit)
  {
     _notifications.CancelNext(habit: habit, hour: 11, minute: 0);
     _notifications.CancelNext(habit: habit, hour: 18, minute: 0);
  }



}

