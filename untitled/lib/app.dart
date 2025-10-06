import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/ViewModel/AddViewModel.dart';
import 'package:untitled/view/Progreso.dart';
import 'view/Add.dart';
import 'componentes/NavigationController.dart';
import 'view/Home.dart';
import 'view/Sound.dart';
import 'services/notiService.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import './l10n/app_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 1;

  static final List<Widget> _screens = <Widget>[
    Progreso(),
    Home(),
    Sound(),
    ChangeNotifierProvider(
      create: (_) => AddViewModel(),
      child: const Add(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    Notiservice.instance.init();
    NavigationController.tabIndex.addListener(() {
      setState(() {
        _selectedIndex = NavigationController.tabIndex.value;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      initialRoute: '/',
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromARGB(255, 197, 29, 227),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Progreso',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note_outlined),
              label: 'Sonidos',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Agregar'),
          ],
        ),
      ),
    );
  }
}
