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

  

  ReminderSettings({


    required this.enable,
    required this.pers,
    required this.notificacioens
  });
}


