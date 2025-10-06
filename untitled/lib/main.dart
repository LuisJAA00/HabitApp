import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'package:untitled/ViewModel/CountDownVM.dart';
import 'package:untitled/ViewModel/HomeViewModel.dart';
import 'package:untitled/services/DBservice.dart';
import 'package:untitled/model/hiveObjects/HabitProgress.dart';

import 'package:untitled/model/hiveObjects/ReminderSettings.dart';

import 'app.dart';
import 'model/hiveObjects/Habit.dart';


//para

void main() async {
  //idioma

  //inicializar hiveP
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(HabitProgressAdapter());
  Hive.registerAdapter(TimeOfDayAdapter()); 
  Hive.registerAdapter(ReminderSettingsAdapter());


  await Hive.openBox<Habit>("test7");
  await DBHelper.instance.init();


  WidgetsFlutterBinding.ensureInitialized();
  // dispositivo ~/Android/Sdk/emulator/emulator -avd Pixel_9 -gpu swiftshader_indirect -no-audio

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => Countdownvm())
      ],
      child: const MyApp(), 
    ),);
}
