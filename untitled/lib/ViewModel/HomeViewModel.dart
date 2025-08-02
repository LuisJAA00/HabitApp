import 'package:flutter/material.dart';
import 'package:untitled/componentes/notificationsApi.dart';
import 'package:untitled/model/Habit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled/model/NoTimeHabit.dart';
import 'package:untitled/screens/Add.dart';

class HomeViewModel extends ChangeNotifier {
  final Box<Habit> _box = Hive.box<Habit>("test3");

  List<Habit> _paraHoy = [];
  NoTimeHabit noTimeHabits = NoTimeHabit.instance;
  List<Habit> _yaRealizados = [];
  Map<int, List<Habit>> _proximosDias = {};
  NoTimeHabit noTimeHabit = NoTimeHabit.instance;
  List<Habit> get paraHoy => _paraHoy;
  List<Habit> get yaRealizados => _yaRealizados;
  Map<int, List<Habit>> get proximosDias => _proximosDias;
  bool get isEmpty => _box.isEmpty;

  HomeViewModel() {
    _init();
  }

  void _init() {
    // Escuchar cambios en la caja Hive
    _box.listenable().addListener(_processHabits);
    _processHabits();
  }

  void _processHabits() {
    final ahora = DateTime.now();
    final todayWeekday = ahora.weekday - 1; // 0 = lunes

    _paraHoy = [];
    _yaRealizados = [];
    _proximosDias = {};

    for (final habit in _box.values) {
      final isDoneToday = habit.progress.date.day == ahora.day;

      if (habit.frecuency == "diario") {
        if (isDoneToday) {
          _yaRealizados.add(habit);
        } else {
          _paraHoy.add(habit);
        }
      } else if (habit.frecuency == "diasEspecificos") {
        if (habit.progress.daysTodoHabit[todayWeekday] == 1) {
          if (isDoneToday) {
            _yaRealizados.add(habit);
          } else {
            _paraHoy.add(habit);
          }
        } else {
          final nextDay = _getNextDay(habit.progress.daysTodoHabit);
          if (!_proximosDias.containsKey(nextDay)) {
            _proximosDias[nextDay] = [];
          }
          _proximosDias[nextDay]!.add(habit);
        }
      }
    }

    notifyListeners();
  }

  int _getNextDay(List<int> dias) {
    final now = DateTime.now();
    final todayWeekday = now.weekday - 1;

    for (int offset = 1; offset <= 7; offset++) {
      final nextDay = (todayWeekday + offset) % 7;
      if (dias[nextDay] == 1) {
        return nextDay;
      }
    }
    return -1; // nunca debería ocurrir
  }

  void habitDone(Habit habit)
  {
    if (DateTime.now().difference(habit.progress.date).inHours >= 24) { // solo una vez por día
  //actualiza ultima vez hecho a hoy, suma veces hecho +1
  habit.progress.date = DateTime.now();
  habit.progress.vecesCompletado++;
  habit.save();
}else{

  return;
}

  if (habit.reminder?.enable == true) {
    // ¿recordatorios activos?

    // ¿es el tiempo activo?
    if (habit.reminder?.time != null) {

      if (habit.reminder!.time!.hour >= DateTime.now().hour &&
          habit.reminder!.time!.minute >= DateTime.now().minute) {

      NotificationApi.instance.CancelNext(
          habit: habit,
          hour: habit.reminder!.time!.hour,
          minute: habit.reminder!.time!.minute,
        );
        
        }

    } 
    else {
     // noTimeHabits.deleteNotificationNext(habit);
    }



  }else{
    //no se hace nada, no hay recordatorios que cancelar...
  }

                
                        
}

  void editHabit(Habit habit,context)
  {
    Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Add(existingHabit: habit),
                ),
              );

    
  }

  void deleteHabit(Habit habit) {
    final key = habit.key as int?;

    if (key != null) {
      if (habit.reminder?.time != null) {
        print("borrando habito");
        NotificationApi.instance.cancel(
          habit: habit,
          hour: habit.reminder!.time!.hour,
          minute: habit.reminder!.time!.minute,
        );
      }
      else{
      print("no time habit elimination trigerd...");
       noTimeHabit.deleteNotifications(habit);
      }

      _box.delete(key);

    }
  }

  @override
  void dispose() {
    _box.listenable().removeListener(_processHabits);
    super.dispose();
  }
}
