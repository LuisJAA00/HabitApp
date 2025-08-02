import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:untitled/componentes/notificationsApi.dart';
import 'package:untitled/model/HabitProgress.dart';
import 'package:untitled/model/NoTimeHabit.dart';
import 'package:untitled/model/ReminderSettings.dart';
import '../model/Habit.dart';

class AddViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final Box<Habit> _box = Hive.box<Habit>("test3");

  // Estado del formulario
  String title = '';
  bool usesTimer = false;
  int goalPerWeek = 1;
  Duration duration = const Duration(minutes: 5);
  String frequency = 'diario';
  List<bool> selectedDays = List.filled(7, false);
  bool isReminderEnable = true;
  bool noSpecificTime = false;
  TimeOfDay? selectedTime;
  int goalPerDay = 1;

  Habit? existingHabit;

  void init(Habit? habit) {
    if (habit == null) return;

    existingHabit = habit;

    title = habit.name;
    usesTimer = habit.usesTimer;
    frequency = habit.frecuency;

    final progress = habit.progress;
    final reminder = habit.reminder;

    duration = Duration(minutes: progress.timeToCompleteHabit ?? 0);
    goalPerWeek = progress.numeroVecesSemana;
    goalPerDay = progress.timesXday;
    selectedDays = List<bool>.generate(
      7,
      (index) => progress.daysTodoHabit[index] == 1,
    );

    if (reminder != null) {
      isReminderEnable = reminder.enable;
      noSpecificTime = reminder.time == null;
      selectedTime = reminder.time;
    }

    notifyListeners();
  }

  Habit toHabit(){
    
    final prog = progress();
    final rem = reminder();

    print("fecha de inicio ${prog.date}");
    print("fecha de inicio2 ${prog.startedAt}");
    print("notificacioens hora ${rem.time}");

    return Habit(name: this.title, usesTimer: usesTimer, frecuency: this.frequency, progress: prog, reminder: rem);
    
  }
void generateEditHabit(Habit habit){
  if(habit.reminder?.time != null)
  {
    deleteHabitNotifications(habit);
  }
  else
  {
    //NoTimeHabit.instance.deleteHabitFromList(habit.key);
  }
  


}
void deleteHabitNotifications(Habit habit) {
    final key = habit.key as int?;

    if (key != null) {
      if (habit.reminder?.time != null) {
        print("borrando notificaciones");
        NotificationApi.instance.cancel(
          habit: habit,
          hour: habit.reminder!.time!.hour,
          minute: habit.reminder!.time!.minute,
        );
      }
      else{
        //NoTimeHabit.instance.deleteNotification(habit);
      }
    }
  }

  HabitProgress progress()
  {
    print("creando habito, date:");
    print(DateTime.now());
    return HabitProgress(date: DateTime.now().subtract(Duration(days: 1)), vecesCompletado: 0, isActive: true, startedAt: DateTime.now(), numeroVecesSemana: (frequency == "xPorSemana")
                          ? this.goalPerWeek
                          : 1, daysOfWeekCompleted: [0, 0, 0, 0, 0, 0, 0], timeToCompleteHabit: duration.inMinutes, daysTodoHabit: selectedDays.map((b) => b ? 1 : 0)
                          .toList(), timesXday: goalPerDay, minutesCompleted: 0);
  }

  ReminderSettings reminder()
  {
return ReminderSettings(reminderFrec: frequency, timesPerWeek: (frequency == "xPorSemana")
                          ? goalPerWeek
                          : 0, 
                          time: (isReminderEnable && !noSpecificTime)
    ? (selectedTime ?? TimeOfDay.now())
    : null, enable: isReminderEnable);
  }
  


  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void toggleUsesTimer(bool value) {
    usesTimer = value;
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

  void toggleDay(int index) {
    selectedDays[index] = !selectedDays[index];
    notifyListeners();
  }

  void toggleReminder(bool value) {
    isReminderEnable = value;
    notifyListeners();
  }

  void toggleNoSpecificTime(bool value) {
    noSpecificTime = value;
    if (value) selectedTime = null;
    notifyListeners();
  }

  void setTime(TimeOfDay? time) {
    selectedTime = time;
    notifyListeners();
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

  List<int> get daysAsIntList => selectedDays.map((b) => b ? 1 : 0).toList();
}
