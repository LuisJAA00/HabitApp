import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:untitled/ViewModel/AddViewModel.dart';
import 'package:untitled/ViewModel/HomeViewModel.dart';
import 'package:untitled/model/DBHelper.dart';
import 'package:untitled/model/HabitProgress.dart';

import 'package:untitled/model/ReminderSettings.dart';

import 'app.dart';
import './model/Habit.dart';
import 'model/HabitService.dart';

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


  await Hive.openBox<Habit>("test3");
  await DBHelper.instance.init();


  WidgetsFlutterBinding.ensureInitialized();
  // dispositivo ~/Android/Sdk/emulator/emulator -avd Pixel_9 -gpu swiftshader_indirect -no-audio

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        // otros ViewModels si los hay
      ],
      child: const MyApp(), 
    ),);
}
