
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_timezone/timezone_info.dart';

import 'package:timezone/data/latest.dart' as tz;

import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import 'package:untitled/model/hiveObjects/Habit.dart';

class Notiservice {
  // Singleton: instancia única
  static final Notiservice instance = Notiservice._internal();

  // Plugin de notificaciones
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Constructor privado
  Notiservice._internal();
FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
    _notificationsPlugin;

  // Inicialización
  Future<void> init() async {
    tz.initializeTimeZones();

    final TimezoneInfo localTimezone = await FlutterTimezone.getLocalTimezone();
    final String timezoneName = localTimezone.identifier;

    //setLocalLocation(tz.getLocation(timezoneName));

    tz.setLocalLocation(tz.getLocation(timezoneName));
  
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

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
          'instant_notifications_channel_id2',
          'Instant Notifications',
          channelDescription: "instant notification channel",
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
  bool _dateInRange(DateTime time, DateTime infLim, DateTime supLim)
  {
    if(time.isAfter(infLim) && time.isBefore(supLim))
    {
      return true;
    }
    return false;
  }

  Future<void> instantAlarm() async {
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'instant_channelv2',
    'Instant Notifications',
    channelDescription: 'Canal para alarmas instantáneas',
    importance: Importance.max,
    priority: Priority.high,
    fullScreenIntent: true,
    ticker: 'ticker',
    autoCancel: false,
    enableVibration: true,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alarm1')
  );

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // id de notificación
    '¡Alarma!',
    'Tu hábito ha finalizado',
    platformDetails,
    payload: 'habito_terminado',
  );
}
  void cancelNext(Habit habit) async
  {
    DateTime now = DateTime.now();
    Map map = habit.reminder.notificacioens; // fecha, id

    
    for (DateTime t in List.from(map.keys)) {
      final kInf = t.subtract(Duration(minutes: 20));
      print("esta now en el rango? t:" + t.toString());
      print("inf" + kInf.toString());
      print("resultado" + _dateInRange(DateTime.now(), kInf, t).toString());

      if(kInf.isAfter(DateTime.now())){
        break; //aun no es esa fecha
      }

      if (t.isBefore(now)) {
      // eliminar notificaciones pasadas, notificacion ya usada
        map.remove(t);
      }
      else if(_dateInRange(DateTime.now(), kInf, t))
      {
        cancelNotification(map[t]);
        print("procediendo a eliminar "+t.toString());
        map.remove(t);
        break;
      }
      /*if (k.isBefore(now)) {
      // eliminar notificaciones pasadas
      
      map.remove(k);
      } else if (k.year == now.year &&
             k.month == now.month &&
             k.day == now.day &&
             k.isAfter(now)) {
      // eliminar la próxima notificación de hoy
        cancelNotification(map[k]);
        map.remove(k);
        break; // solo eliminamos una
      }
      */
    }
  }


  Future<void> cancelNotification(int id )
  async{
      await _notificationsPlugin.cancel(id);
  }



  Future<void> scheduleReminder({
    required int id, 
    required String title,
    required tz.TZDateTime scheduleTime, //el momento exacto de la notificacion
    String? body,
  }) async {
    tz.TZDateTime scheduleDate = scheduleTime;

    final androidPlugin = _notificationsPlugin
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

final canUseExact = await androidPlugin?.canScheduleExactNotifications() ?? false;


    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_nootifications_channel_id2vSound',
          'Daily Reminders',
          channelDescription: "reminder to complete daily habit...",
          importance: Importance.max,
          priority: Priority.high,
          //playSound: true,
          //sound: RawResourceAndroidNotificationSound('alarm1')
        ),
        iOS: DarwinNotificationDetails(),
      ),
      //androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      androidScheduleMode: canUseExact
      ? AndroidScheduleMode.exactAllowWhileIdle
      : AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  int genId(int key , DateTime dateTime) {


  final keyStr = key.toString().padLeft(3, '0');

  final dayStr = dateTime.day.toString().padLeft(2, '0');

  final hourStr = dateTime.hour.toString().padLeft(2, '0');

  final minStr = dateTime.minute.toString().padLeft(2, '0');


  final idStr = '$hourStr$minStr$dayStr$keyStr';

  return int.parse(idStr); // ejemplo: 07171345
  
  // 31 bits -> MAX: 2147483648 (10 DIGITOS)

  //Dia 2 digitos
  //Hora 2 digitos
  // minuto 2 digitos

  //id, suponiendo maximo de 999 -> 3 digitos

  

 }

 
}
