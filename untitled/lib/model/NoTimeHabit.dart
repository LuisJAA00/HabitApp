


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:untitled/componentes/notificationsApi.dart';
import 'package:untitled/model/DBHelper.dart';
import 'package:untitled/model/Habit.dart';
import 'package:untitled/model/HabitService.dart';
import 'package:untitled/model/NoTimeHabitHelper.dart';


class NoTimeHabit  {

  final box = DBHelper.instance.habitBox;
  // final allHabits = box.values.toList();

  static final NoTimeHabit _instance = NoTimeHabit._internal();
  
  // 2. Constructor privado
  NoTimeHabit._internal();

  // 3. Acceso global a la instancia
  static NoTimeHabit get instance => _instance;


  NoTimeHabitHelper helper = NoTimeHabitHelper();
  DBHelper db = DBHelper.instance;
  

  void updateNotifications(Habit h) {
    //1 checar frecuencia habito
    switch (h.frecuency)
    {
      case 'diario':

          for(final habit in box.values)
          {
            if(habit.reminder!.enable)
            {
              if(habit.frecuency == "diario" && habit.progress.startedAt == h.progress.startedAt)
              {
                //existe un habito el mismo dia que ya esta guardado con notificaciones iguales...
                //no es necesario hacer nada
                return;
              }
            }
          }
          
        break;
      case 'xPorSemana':
          //
        break;
      case 'diasEspecificos':
        for(final habit in box.values)
          {
            if(habit.reminder!.enable)
            {
              if(habit.frecuency == "diario" && habit.progress.startedAt == h.progress.startedAt)
              {
                //existe un habito el mismo dia que ya esta guardado con notificaciones iguales...
                //no es necesario hacer nada
                return;
              }
            }
          }
        break;
    }
    helper.updateNotificationsDaily(h);


    }




    
  

  void deleteNotifications(Habit h) {
    final now = DateTime.now();
    

    for(int i = 0; i < 30; i++)
    {
      final futureDay = now.add(Duration(days: i));
      helper.deleteNotifications(h, futureDay);
    }


  }


  void deleteNextNotification(Habit h) {
    helper.deleteNotificationNext(h);
  }


}


//corregir edit y adding... hay algo mal ahi