
import 'package:untitled/model/hiveObjects/Habit.dart';

abstract class HabitNotificationStrategy {

  
  Future<void> borrarNotificaciones(Habit habit);
  Future<void> agendarNotificaciones(Habit habit,DateTime hora);

  
}