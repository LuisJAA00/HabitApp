import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/ViewModel/AddViewModel.dart';
import 'package:untitled/services/DBservice.dart';
import 'package:untitled/model/hiveObjects/Habit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled/model/HabitBase.dart';
import 'package:untitled/repos/DBrepo.dart';
import 'package:untitled/repos/NotiRepo.dart';
import 'package:untitled/view/Add.dart';
import 'package:untitled/view/HabitCountDown.dart';

class HomeViewModel extends ChangeNotifier {
  final Box<Habit> _box = DBHelper.instance.habitBox;

  /////
  ///repos
  NotiRepo notiRepo = new NotiRepo();
  DBrepo dbRepo = new DBrepo();
  ///
  ///
  ///
  //////

  List<Habitbase> _paraHoy = [];
  List<Habitbase> _yaRealizados = [];
  Map<int, List<Habitbase>> _proximosDias = {};
  List<Habitbase> get paraHoy => _paraHoy;
  List<Habitbase> get yaRealizados => _yaRealizados;
  Map<int, List<Habitbase>> get proximosDias => _proximosDias;
  bool get isEmpty => _box.isEmpty;

  HomeViewModel() {
    _init();
  }

  void _init() {
    // Escuchar cambios en la caja Hive
    _box.listenable().addListener(_processHabits);
    for (final habit in DBHelper.instance.getAllHabits()){
      if(habit.reminder.notificacioens.isEmpty && habit.reminder.enable)
      {
        // Generar notificaciones a partir del ultima dia con notificaciones pendientes
        // Haste tener nuevamente al menos 30 notificaciones listas.
        reAgendarNot(habit);
      }
    }
    _processHabits();
  }

  void _processHabits() {
    
    
    final ahora = DateTime.now();
    final todayWeekday = ahora.weekday - 1; // 0 = lunes

    _paraHoy = [];
    _yaRealizados = [];
    _proximosDias = {};

    //Obten todos los habitos y agrupalos
    for (final habit in DBHelper.instance.getAllHabits()) {

      DateTime ultima = habit.progress.date;
      DateTime hoy = DateTime.now();

      // Reinicia veces completado cada dia.
      if  (ultima.year < hoy.year || 
        (ultima.year == hoy.year && ultima.month < hoy.month) || 
        (ultima.year == hoy.year && ultima.month == hoy.month && ultima.day < hoy.day)) {

        habit.progress.vecesCompletado = 0;
        //print("Última vez hecho fue " + ultima.toString());
        //print("Reiniciado veces por día");
      }

      // Reagenda notificaciones si ya se consumieron la mayoria


      //final isDoneToday = habit.lastDateDone.day == ahora.day; // CHECAR
      final isDoneToday = habit.progress.vecesCompletado == habit.reminder.horarios.length;
      if (habit.frecuency == "diario") {
        if (isDoneToday) {
          _yaRealizados.add(habit);
        } else {
          _paraHoy.add(habit);
        }
      } else if (habit.frecuency == "diasEspecificos") {
        if (habit.daysTodoHabit[todayWeekday] == 1) {
          if (isDoneToday) {
            _yaRealizados.add(habit);
          } else {
            _paraHoy.add(habit);
          }
        } else {
          final nextDay = _getNextDay(habit.daysTodoHabit);
          if (!_proximosDias.containsKey(nextDay)) {
            _proximosDias[nextDay] = [];
          }
          _proximosDias[nextDay]!.add(habit);
        }
      } else if (habit.frecuency == "diasEspecificos")
      {

      }
    }

    notifyListeners();
  }

  reAgendarNot(Habitbase habit)
  {
    notiRepo.reAgendarNotificaciones(habit.habit);
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

  void habitDone(Habitbase habit,BuildContext context)
  async
  {

   /* DateTime ultima = habit.progress.date;
    DateTime hoy = DateTime.now();

    // Comparar año, mes y día
    if (ultima.year < hoy.year || 
      (ultima.year == hoy.year && ultima.month < hoy.month) || 
      (ultima.year == hoy.year && ultima.month == hoy.month && ultima.day < hoy.day)) {

      habit.progress.vecesCompletado = 0;
      print("Última vez hecho fue " + ultima.toString());
      print("Reiniciado veces por día");
    }
    */

    if(habit.progress.vecesCompletado == habit.vecesPorDia)
    {
      //completado el objetivo este dia
      print("completado el objetivo de hoy, sin cambios");
      return;
    }
    
    if (habit.usesTimer) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HabitCountdown(habit: habit.habit,onFinish: ()
        {
          notiRepo.borrarNextNotificacion(habit);
          Navigator.pop(context);
          habit.progress.date = DateTime.now();
          habit.progress.vecesCompletado++;
          habit.progress.totalCompletions++;
          if(habit.progress.timeToCompleteHabit != null)
          {
            habit.progress.minutesCompleted = habit.progress.totalCompletions*habit.progress.timeToCompleteHabit! ;
          }
          habit.habit.save();


          
        }
        ,notiRepo: notiRepo,)),
      );
      
  }
  else{
    notiRepo.borrarNextNotificacion(habit);

    habit.progress.date = DateTime.now();
    habit.progress.vecesCompletado++;
    habit.progress.totalCompletions++;
    if(habit.progress.timeToCompleteHabit != null)
    {
      habit.progress.minutesCompleted = habit.progress.totalCompletions*habit.progress.timeToCompleteHabit! ;
    }
    habit.habit.save();
  }
    
  
               
  }

  void editHabit(Habitbase habit,context)
  {
    Navigator.push(
                context,
                MaterialPageRoute(
                   builder: (context) => ChangeNotifierProvider(
                    create: (_) => AddViewModel()..init(habit.habit),
                    child: Add(existingHabit: habit.habit),
                  ),
                ),
              );
   
    
  }

  void deleteHabit(Habitbase habit) {

    final key = habit.key as int?;
    if (key != null) {
      notiRepo.deleteNotification(habit.habit);
      dbRepo.borrarHabit(habit);
    }
    
  }

  @override
  void dispose() {
    _box.listenable().removeListener(_processHabits);
    super.dispose();
  }
}
