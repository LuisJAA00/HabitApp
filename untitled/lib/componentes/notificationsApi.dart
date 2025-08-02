import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/model/Habit.dart';

class NotificationApi {
  // Singleton: instancia única
  static final NotificationApi instance = NotificationApi._internal();

  // Plugin de notificaciones
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Constructor privado
  NotificationApi._internal();
FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
    _notificationsPlugin;

  // Inicialización
  Future<void> init() async {
    tz.initializeTimeZones();

    final String localTZ = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTZ));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  // Notificación instantánea
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notifications_channel_id',
          'Instant Notifications',
          channelDescription: "instant notification channel",
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> cancel({required habit, required hour, required minute}) async {
    switch (habit.reminder.reminderFrec) {
      case 'diario':
        _cancelDiario(habit, hour, minute);
        break;
      case 'xPorSemana':
        break;
      case 'diasEspecificos':
        _cancelSeleccionados(habit, hour, minute);
        break;
    }
  }

  Future<void> CancelNext({required habit, required hour, required minute}) async
  {
    
    
    switch (habit.reminder.reminderFrec) {
      case 'diario':
        _cancelNextDiario(habit, hour, minute);
        break;
      case 'xPorSemana':
        break;
      case 'diasEspecificos':
        _cancelNextSeleccionado(habit, hour, minute);
        break;
    }

  }

  void _cancelNextDiario(habit, hour, minute) async
  {
    //cada id es generado respecto a la fecha y hora, este metodo solo se llama si es antes de la hora programada
    //como es diario y se llama solo si es antes de la siguiente noti, entonces cancelamos notificacion de hoy

    //id de notificacion de hoy = genID( fecha hoy )

    final key = habit.key;
    final scheduledDay = DateTime.now();

    final scheduledTime = tz.TZDateTime(
        tz.local,
        scheduledDay.year,
        scheduledDay.month,
        scheduledDay.day,
        hour,
        minute,
        0,
    );

    final notiID = genId(key, scheduledTime);
    print("eliminando $notiID");

    await _notificationsPlugin.cancel(notiID);

  }

  void _cancelNextSeleccionado(habit, hour, minute) async
  {

    final key = habit.key;
    final scheduledDay = DateTime.now();

    final diaSemana = scheduledDay.weekday - 1 ;

    if(habit.progress.daysTodoHabit[diaSemana] != 1)
    {
      return;
    }

    final scheduledTime = tz.TZDateTime(
        tz.local,
        scheduledDay.year,
        scheduledDay.month,
        scheduledDay.day,
        hour,
        minute,
        0,
    );

    final notiID = genId(key, scheduledTime);

    await _notificationsPlugin.cancel(notiID);
  }

  void _cancelDiario(habit, hour, minute) async {
    final key = habit.key;

    for (
      int i = 0;
      i < 31 - DateTime.now().difference(habit.progress.date).inDays;
      i++
    ) { 


      final scheduledDay = DateTime.now().add(Duration(days: i));

      final scheduledTime = tz.TZDateTime(
        tz.local,
        scheduledDay.year,
        scheduledDay.month,
        scheduledDay.day,
        hour,
        minute,
        0,
      );

      final id = genId(key,scheduledTime);

      await _notificationsPlugin.cancel(id);
    }
  }

  void _cancelSeleccionados(habit, hour, minute) async {
    final key = habit.key;
    for (
      int i = 0;
      i < 31 - DateTime.now().difference(habit.progress.date).inDays;
      i++
    ) {


      final scheduledDay = DateTime.now().add(Duration(days: i));

      int weekdayIndex = scheduledDay.weekday - 1;

      if (habit.progress.daysTodoHabit[weekdayIndex] == 1) {
        //el dia esta seleccionado...
        final scheduledTime = tz.TZDateTime(
          tz.local,
          scheduledDay.year,
          scheduledDay.month,
          scheduledDay.day,
          hour,
          minute,
          0,
        );

        final id = genId(key,scheduledTime);
        await _notificationsPlugin.cancel(id);
      }
    }
  }

  Future<void> scheduleReminder({
    required int id, 
    required String title,
    required tz.TZDateTime scheduleTime, //el momento exacto de la notificacion
    String? body,
  }) async {
    tz.TZDateTime scheduleDate = scheduleTime;

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_nootifications_channel_id',
          'Daily Reminders',
          channelDescription: "reminder to complete daily habit...",
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      //matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  int genId(int key , DateTime dateTime) {


  final keyStr = key.toString().padLeft(3, '0');

  final dayStr = dateTime.day.toString().padLeft(2, '0');

  final hourStr = dateTime.hour.toString().padLeft(2, '0');

  final minStr = dateTime.minute.toString().padLeft(2, '0');


  final idStr = '$hourStr$minStr$keyStr$dayStr';

  return int.parse(idStr); // ejemplo: 07171345
  
  // 31 bits -> MAX: 2147483648 (10 DIGITOS)

  //Dia 2 digitos
  //Hora 2 digitos
  // minuto 2 digitos

  //id, suponiendo maximo de 999 -> 3 digitos

  

 }
void cancelSingleNot(Habit habit, DateTime when) async
{
  final id = genId(NoTimeHabitsID.id,when);
  print("eliminado notificacion con id  ${id}");
  await _notificationsPlugin.cancel(id);
}
 
}
