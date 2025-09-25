import 'package:untitled/services/DBservice.dart';
import 'package:untitled/model/HabitBase.dart';
import 'package:untitled/model/hiveObjects/Habit.dart';

class DBrepo{
  DBHelper db = DBHelper.instance;

  Future<bool> nameInUse(String name)
  async{
    return db.habitBox.values.any((h) => h.name == name);
  }

  void saveHabit(Habit habit)
  {
    db.habitBox.add(habit);
  }

  void updateHabit(Habit habit)
  {
    db.habitBox.put(habit.key, habit);
  }

  void borrarHabit(Habitbase habit)
  {
    final key = habit.key as int?;
    if (key != null) {
      DBHelper.instance.habitBox.delete(key);
    }
  }


}