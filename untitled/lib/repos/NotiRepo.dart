//import 'package:flutter/material.dart';
import 'package:untitled/services/notiService.dart';
import 'package:untitled/model/HabitBase.dart';
import 'package:untitled/model/hiveObjects/Habit.dart';
import 'package:untitled/model/intefaz/DiarioHabitStrat.dart';
import 'package:untitled/model/intefaz/HabitNotificationStrategy.dart';
import 'package:untitled/model/intefaz/SeleccionadosHabitStrat.dart%20copy.dart';

class NotiRepo {
  final Map<String, HabitNotificationStrategy> _strategies;
  bool hasPassed24hrs(Habit habit)
  {
    if (DateTime.now().difference(habit.progress.date).inHours >= 24) { // solo una vez por día
      return true;
    }
    else{
      return false;
    }
  }

  NotiRepo()
      : _strategies = {
          "diario": DiarioHabitStrat(),
          //"xPorSemana": HabitBStrategy(),
          "diasEspecificos": SeleccionadosHabitStrat(),
        };




  Future<void> deleteNotification(Habit habit) async {


    final strategy = _strategies[habit.frecuency];
    if (strategy != null) {
      print("borrando notificaciones");
      //await strategy.borrarNotificaciones(habit);
      borrarNotificaciones(habit);
      return;
    }
  }

  void borrarNotificaciones(Habit habit)
  async{
    Map map = habit.reminder!.notificacioens;

    for(DateTime k in map.keys)
    {
      print("eliminando " + k.toString() + " con id " + map[k].toString());
      Notiservice.instance.cancelNotification(map[k]);
    }
    map.clear();

    await habit.save();
  }

  Future<void> borrarNextNotificacion(Habitbase habit) async {
    if(!hasPassed24hrs(habit.habit)) //solo funciona para habitos con una sola noti...
    {
      return;
    }

    habit.progress.date = DateTime.now();
    habit.progress.vecesCompletado++;
    habit.habit.save();

    //final strategy = _strategies[habit.frecuency];
    
    if (habit.reminder?.enable == true) {
    // ¿recordatorios activos?
      Notiservice.instance.cancelNext(habit.habit);
    }

  }


  Future<void> agendarNotificaciones(Habit habit, List<DateTime> horas) async {
    

    final strategy = _strategies[habit.frecuency];
    if (strategy != null) {

     if(horas.isEmpty)
      {
        print("INVALIDO, HORAS ESTA VACIO");
      } 
      for (DateTime h in List.from(horas)) {
        await strategy.agendarNotificaciones(habit, h);
      }

    var map = habit.reminder!.notificacioens;
    for(var k in map.keys){
      print("en la fecha " + k.toString() + " se guarda el id " + map[k].toString());
    }
    habit.save();
      return;
    }
  }

  int genID(DateTime time, int key)
  {
    return Notiservice.instance.genId(key, time);
  }
}