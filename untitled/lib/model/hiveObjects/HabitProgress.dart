import 'package:hive/hive.dart';

part 'HabitProgress.g.dart';

@HiveType(typeId: 1)
class HabitProgress extends HiveObject {
  @HiveField(0)
  DateTime date; //para registrar cuando se hizo por ultima vez

  @HiveField(1)
  int vecesCompletado; // cuantas veces se ha completado con exito

  @HiveField(2)
  bool isActive; //se puede desactivar/activar un habito durante un tiempo indefinido,
  //quiza el usuario no prodra realizarlo un tiempo...

  @HiveField(3)
  DateTime? startedAt; //cuando se empezo a realizar el habito?

  @HiveField(4)
  int numeroVecesSemana; //numero de veces que debe ser realizado el habito... en la semana

  @HiveField(5)
  List<int> daysOfWeekCompleted;

  @HiveField(6)
  List<int> daysTodoHabit; //que dias se hace el habito

  @HiveField(7)
  int timesXday = 1; //cuantas veces al dia

  @HiveField(8)
  int? timeToCompleteHabit; //cuantos minutos se debe hacer para completar el habito (si es que lleva timer)

  @HiveField(9)
  int? minutesCompleted; //minutos que se ha hecho el habito (solo si es con timer)

  HabitProgress({
    required this.date,
    required this.vecesCompletado,
    required this.isActive,
    required this.startedAt,
    required this.numeroVecesSemana,
    required this.daysOfWeekCompleted,
    required this.timeToCompleteHabit,
    required this.daysTodoHabit,
    required this.timesXday,
    required this.minutesCompleted,
  });
}
