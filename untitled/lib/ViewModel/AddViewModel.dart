
import 'package:flutter/material.dart';
import 'package:untitled/model/hiveObjects/HabitProgress.dart';
import 'package:untitled/model/hiveObjects/ReminderSettings.dart';
import 'package:untitled/repos/DBrepo.dart';
import 'package:untitled/repos/NotiRepo.dart';
import '../model/hiveObjects/Habit.dart';

class AddViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  /////
  ///repos
  NotiRepo notiRepo = new NotiRepo();
  DBrepo dbRepo = new DBrepo();
  ///
  ///
  ///
  //////
  


  // Estado del formulario

  bool usesTimer = false;
  bool persNot = false;
  int goalPerWeek = 1;
  Duration duration = const Duration(minutes: 5);
  String frequency = 'diario';
  List<bool> selectedDays = List.filled(7, false);
  bool isReminderEnable = true;
  bool noSpecificTime = false;
  List<DateTime> selectedTime = [];
  final titleController = TextEditingController();
  
  int goalPerDay = 1;
  Habit? existingHabit;

  void init(Habit? habit) {
    if (habit == null) return;

    existingHabit = habit;

    titleController.text = habit.name;
    usesTimer = habit.usesTimer;
    frequency = habit.frecuency;

    final progress = habit.progress;
    final reminder = habit.reminder;

    duration = Duration(minutes: progress.timeToCompleteHabit ?? 5);
    goalPerWeek = progress.numeroVecesSemana;
    goalPerDay =  reminder.horarios.length;//progress.totalCompletions;
    selectedDays = List<bool>.generate(
      7,
      (index) => progress.daysTodoHabit[index] == 1,
    );

    /*if (reminder != null) {
      isReminderEnable = reminder.enable;
      noSpecificTime = false;
      //selectedTime = reminder.time;
    }*/

    notifyListeners();
  }

  Habit toHabit(){
    
    final prog = progress();
    final rem = reminder();


    return Habit(name: titleController.text, usesTimer: usesTimer, frecuency: frequency, progress: prog, reminder: rem);
    
  }

void generateEditHabit(Habit newHabit, Habit existingHabit,List<DateTime> horas){
  if(existingHabit.reminder.enable == false || horas.isEmpty)//se eliminaron las notificaciones y no se signan nuevas
  {
    notiRepo.deleteNotification(existingHabit);

    existingHabit.name = newHabit.name;
    existingHabit.frecuency = newHabit.frecuency;
    existingHabit.progress = newHabit.progress;
    existingHabit.reminder = newHabit.reminder;
    existingHabit.usesTimer = newHabit.usesTimer;
  }
  else //eliminar las notificaciones viejas y reagendar... //guardar
  {
    notiRepo.deleteNotification(existingHabit);
    //dbRepo.saveHabit(habit);
    existingHabit.reminder.horarios = horas;
    existingHabit.name = newHabit.name;
    existingHabit.frecuency = newHabit.frecuency;
    existingHabit.progress = newHabit.progress;
    existingHabit.reminder = newHabit.reminder;
    existingHabit.usesTimer = newHabit.usesTimer;
    notiRepo.agendarNotificaciones(existingHabit,horas);
  }
    
  

  dbRepo.updateHabit(existingHabit);
  print("editado con exito");
}


  Future<bool> nameInUse(String name)
  {
    return dbRepo.nameInUse(name);
  }

  void removeTime(DateTime time)
  {
    selectedTime.remove(time);
    notifyListeners();
  }

  void removeExistingTime(time)
  {
    if(existingHabit != null && existingHabit!.reminder.horarios.isNotEmpty)
    {
      existingHabit!.reminder.horarios.remove(time);
      notifyListeners();
    }
    
  }

  void saveHabit(Habit habit,List<DateTime> horas)
  {
    dbRepo.saveHabit(habit);
    
    notiRepo.agendarNotificaciones(habit,horas);
  }

 


  HabitProgress progress()
  {
    print("creando habito, date:");
    print(DateTime.now());
    return HabitProgress(date: DateTime.now().subtract(Duration(days: 1)), vecesCompletado: 0, isActive: true, startedAt: DateTime.now(), numeroVecesSemana: (frequency == "xPorSemana")
                          ? this.goalPerWeek
                          : 1, daysOfWeekCompleted: [0, 0, 0, 0, 0, 0, 0], timeToCompleteHabit: duration.inMinutes, daysTodoHabit: selectedDays.map((b) => b ? 1 : 0)
                          .toList(), totalCompletions: 0, minutesCompleted: 0);
  }

  ReminderSettings reminder()
  {
    
    if(existingHabit != null && existingHabit!.reminder.horarios.isNotEmpty)
    {
      print(existingHabit!.reminder.horarios);
      for(int i = 0; i < existingHabit!.reminder.horarios.length; i ++)
      {
        selectedTime.add(existingHabit!.reminder.horarios[i]);
      }
    }
    print("selected time " + selectedTime.toString());


    return ReminderSettings(enable: isReminderEnable, pers: persNot, notificacioens: Map<DateTime, int>(),horarios: selectedTime);
  }
  


  void setTitle(String value) {
    titleController.text = value;
    notifyListeners();
  }



  void toggleUsesTimer(bool value) {
    usesTimer = value;
    print("uses timer change "+ usesTimer.toString());
    notifyListeners();
  }

  void togglePersNot(bool value)
  {
    persNot = value;
    notifyListeners();
  }

  void setDuration(int minutes) {
    duration = Duration(minutes: minutes);
   
    notifyListeners();
  }

  void setFrequency(String value) {
    frequency = value;
    notifyListeners();
  }

  void setGoalPerWeek(int value) {
    goalPerWeek = value;
    notifyListeners();
  }

  void toggleDay(int index,[bool diario = false]) {
    selectedDays[index] = !selectedDays[index];
    notifyListeners();
  }

  void toggleReminder(bool value) {
    isReminderEnable = value;
    notifyListeners();
  }

  void toggleNoSpecificTime(bool value) {
    noSpecificTime = value;
    notifyListeners();
  }

  void setTime(TimeOfDay t) {

    DateTime now = DateTime.now();
    DateTime dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    
    
    selectedTime.add(dt);
    notifyListeners();
  }

  void deleteNot(DateTime time){
    selectedTime.remove(time);
    notifyListeners();
  }

  List<DateTime> getCurrentNot()
  {
    return selectedTime;
  }

  void incrementGoalPerDay() {
    if (goalPerDay < 10) {
      goalPerDay++;
      notifyListeners();
    }
  }

  void decrementGoalPerDay() {
    if (goalPerDay > 1) {
      goalPerDay--;
      notifyListeners();
    }
  }

  void restartVM()
  {
  titleController.clear();
  usesTimer = false;
  persNot = false;
  goalPerWeek = 1;
  duration = const Duration(minutes: 5);
  frequency = 'diario';
  selectedDays = List.filled(7, false);
  isReminderEnable = true;
  noSpecificTime = false;
  selectedTime = [];
  existingHabit = null;
  goalPerDay = 1;
  notifyListeners();
  }

  List<int> get daysAsIntList => selectedDays.map((b) => b ? 1 : 0).toList();
}
