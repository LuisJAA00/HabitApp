
import 'package:timezone/timezone.dart' as tz;
import 'package:untitled/constants/constants.dart';
import '../componentes/notificationsApi.dart';
import 'package:untitled/model/Habit.dart';






Future<void> programarRecordatoriosHabitos(Habit habit) async {
  final reminder = habit.reminder;

  if (reminder == null || !reminder.enable) return;

  final now = DateTime.now();

  int? timeHour;
  int? timeMinute;

  

  if (reminder.time == null) {
    //no hay hora en especifico...
    //2 notificaciones en dia especificado 11 am y 6 pm
    //NoTimeHabit.instance.addHabitList(habit);
    switch (habit.frecuency)
    {
      case 'diario':
        scheduleNoTimeNotificationsDaily( habit);
        break;
      case 'xPorSemana':
          //
        break;
      case 'diasEspecificos':
        scheduleNoTimeNotificationsSeleccionados(habit);
        break;
    }
    return;
  } else {
    //tomar hora seleccionada por el usuario

    timeHour = reminder.time?.hour;
    timeMinute = reminder.time?.minute;
    print("hora seleccionada, hora de habito");
    print("${reminder.time?.hour}");
    print("${reminder.time?.minute}");
  }

  final schedule = DateTime(
    now.year,
    now.month,
    now.day,
    timeHour!,
    timeMinute!,
  );

  //hacer los recordatorios

  if (reminder.reminderFrec == 'diario') {
    int idCount = 0;
    for (int i = 0; i < 30; i++) {
      print("agendando notificacion para el");
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
      if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
    
        continue;
      }


      await NotificationApi.instance.scheduleReminder(
        //realiza la agenda de notificacion.
        id: NotificationApi.instance.genId(
         habit.key,scheduledTime
        ), //si el habito tiene id = 1, entonces cada dia seria 11, 12, 13, ... , 17
        title: "${habit.name} $idCount $scheduledTime",
        body: habit.name,
        scheduleTime: scheduledTime,
      );
      idCount++;


    }
  }


  if (reminder.reminderFrec == "diasEspecificos") {
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

        await NotificationApi.instance.scheduleReminder(
          id: NotificationApi.instance.genId(habit.key,scheduledTime),
          title: "${habit.name} $idCount $scheduledTime",
          body: habit.name,
          scheduleTime: scheduledTime,
        );
        idCount++;
      }
    }
  }


  
}
void scheduleNoTimeNotificationsDaily(Habit habit) async 
 {
      final now = DateTime.now();

      for (int i = 0; i < 30; i++) {
        final scheduledDay = now.add(Duration(days: i));
        final scheduledTime1 = tz.TZDateTime(
          tz.local,
          scheduledDay.year,
          scheduledDay.month,
          scheduledDay.day,
          11,
          00,
          0,
        );
   final scheduledTime2 = tz.TZDateTime(
          tz.local,
          scheduledDay.year,
          scheduledDay.month,
          scheduledDay.day,
          18,
          00,
          0,
        );

        if (scheduledTime1.isBefore(tz.TZDateTime.now(tz.local)) || scheduledTime2.isBefore(tz.TZDateTime.now(tz.local))) {
          continue;
        }
      

      await NotificationApi.instance.scheduleReminder(
          id: NotificationApi.instance.genId(NoTimeHabitsID.id,scheduledTime1),
          title: "${habit.name}  $scheduledTime1",
          body: habit.name,
          scheduleTime: scheduledTime1,
        );
      await NotificationApi.instance.scheduleReminder(
          id: NotificationApi.instance.genId(NoTimeHabitsID.id,scheduledTime2),
          title: "${habit.name}  $scheduledTime2",
          body: habit.name,
          scheduleTime: scheduledTime2,
        );
    }

      
 }

void scheduleNoTimeNotificationsSeleccionados(Habit habit) async 
 {
      final now = DateTime.now();
      

      for (int i = 0; i < 30; i++) {
        final scheduledDay = now.add(Duration(days: i));

        int weekdayIndex = scheduledDay.weekday - 1;
        if (habit.progress.daysTodoHabit[weekdayIndex] == 1)
        {
          final scheduledTime1 = tz.TZDateTime(
            tz.local,
            scheduledDay.year,
            scheduledDay.month,
            scheduledDay.day,
            11,
            00,
            0,
          );
          final scheduledTime2 = tz.TZDateTime(
            tz.local,
            scheduledDay.year,
            scheduledDay.month,
            scheduledDay.day,
            18,
            00,
            0,
          );
          if (scheduledTime1.isBefore(tz.TZDateTime.now(tz.local)) || scheduledTime2.isBefore(tz.TZDateTime.now(tz.local))) {
            continue;
          }
          await NotificationApi.instance.scheduleReminder(
            id: NotificationApi.instance.genId(NoTimeHabitsID.id,scheduledTime1),
            title: "${habit.name}  $scheduledTime1",
            body: habit.name,
            scheduleTime: scheduledTime1,
          );
          await NotificationApi.instance.scheduleReminder(
            id: NotificationApi.instance.genId(NoTimeHabitsID.id,scheduledTime2),
            title: "${habit.name}  $scheduledTime2",
            body: habit.name,
            scheduleTime: scheduledTime2,
          );

        }
        
    }

      
 }
