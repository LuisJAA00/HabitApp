import 'package:hive/hive.dart';
import 'package:untitled/model/HabitSeleccionados.dart';
import 'package:untitled/model/hiveObjects/Habit.dart';
import 'package:untitled/model/HabitBase.dart';
import 'package:untitled/model/HabitDiario.dart';
import 'package:untitled/model/HabitPorSemana.dart';

import 'package:untitled/model/hiveObjects/NoTimeNotificationDays.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  DBHelper._internal();
  static DBHelper get instance => _instance;

  static const String _boxName = "test6"; 
  static const String _boxDaysName = "days";
  Box<Habit>? _habitBox;
  Box<NoTimeNotificationDays>? _boxDays;

  /// Inicializa la caja si no está abierta
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _habitBox = await Hive.openBox<Habit>(_boxName);
    } else {
      _habitBox = Hive.box<Habit>(_boxName);
    }

    if (!Hive.isBoxOpen(_boxDaysName)) {
      _boxDays = await Hive.openBox<NoTimeNotificationDays>(_boxDaysName);
    } else {
      _boxDays = Hive.box<NoTimeNotificationDays>(_boxDaysName);
    }
  }

  /// Obtiene la caja abierta (después de llamar a `init`)
  Box<Habit> get habitBox {
    if (_habitBox == null) {
      throw Exception("DBHelper not initialized. Call `await DBHelper.instance.init()` first.");
    }
    return _habitBox!;
  }

  Box<NoTimeNotificationDays> get daysBox {
    if(_boxDays == null )
    {
      throw Exception("DBHelper not initialized. Call `await DBHelper.instance.init()` first.");
    }
    return _boxDays!;
  }

  Future<void> saveNotificationDays(List<DateTime> days) async {
  final obj = NoTimeNotificationDays(days: days);
  await daysBox.put(_boxDaysName, obj);
}

NoTimeNotificationDays? getNotificationDays() {
  return daysBox.get(_boxDaysName);
}

List<Habitbase> getAllHabits() {
  return habitBox.values.map((h) {
    switch (h.frecuency) {
      case "diario":
        return HabitDiario(h);
      case "xPorSemana":
        return HabitPorSemana(h);
      case "diasEspecificos":
        return HabitSeleccionados(h);
      default:
        throw Exception("Tipo de frecuencia no reconocida: ${h.frecuency}");
    }
  }).toList();
}

}
