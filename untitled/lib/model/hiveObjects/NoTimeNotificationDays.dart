
import 'package:hive/hive.dart';

part 'NoTimeNotificationDays.g.dart';

@HiveType(typeId: 2)
class NoTimeNotificationDays extends HiveObject {
  @HiveField(0)
  List<DateTime> days;

  NoTimeNotificationDays({
    required this.days
  });
}
