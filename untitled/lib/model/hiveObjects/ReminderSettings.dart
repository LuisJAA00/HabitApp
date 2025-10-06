
import 'package:hive/hive.dart';

part 'ReminderSettings.g.dart';

@HiveType(typeId: 2)
class ReminderSettings extends HiveObject {

@HiveField(0)
  Map<DateTime, int> notificacioens; // Dia - hora, ID


  @HiveField(1)
  bool enable;

  @HiveField(2)
  bool pers;

  @HiveField(3)
  List<DateTime> horarios = [];

  

  ReminderSettings({


    required this.enable,
    required this.pers,
    required this.notificacioens,
    required this.horarios
  });
}


