import 'package:flutter/material.dart';
import 'package:untitled/componentes/BotonApp.dart';

import 'package:untitled/model/Habit.dart';
import 'package:untitled/model/HabitProgress.dart';
import 'package:untitled/model/ReminderSettings.dart';
import 'package:untitled/screens/Progreso.dart';
import '../componentes/notificationsApi.dart';
import 'package:timezone/timezone.dart' as tz;
import '../model/HabitService.dart';

class Sound extends StatefulWidget {
  const Sound({super.key});

  @override
  State<Sound> createState() => _SoundState();
}

class _SoundState extends State<Sound> {
  List<bool> selectedList = [];

  @override
  void initState() {
    super.initState();
    // Inicializar todos como no seleccionados
    selectedList = List<bool>.filled(items.length, false);
  }

  final List<Map<String, String>> items = [
    {'image': 'assets/test.png', 'text': 'Opción 1'},
    {'image': 'assets/test.png', 'text': 'Opción 2'},
    {'image': 'assets/test.png', 'text': 'Opción 3'},
    {'image': 'assets/test.png', 'text': 'Opción 4'},
    {'image': 'assets/test.png', 'text': 'Opción 5'},
    {'image': 'assets/test.png', 'text': 'Opción 6'},
    {'image': 'assets/test.png', 'text': 'Opción 7'},
    {'image': 'assets/test.png', 'text': 'Opción 8'},
    {'image': 'assets/test.png', 'text': 'Opción 9'},
    {'image': 'assets/test.png', 'text': 'Opción 10'},
    {'image': 'assets/test.png', 'text': 'Opción 11'},
    {'image': 'assets/test.png', 'text': 'Opción 12'},
    {'image': 'assets/test.png', 'text': 'Opción 13'},
    {'image': 'assets/test.png', 'text': 'Opción 14'},
    {'image': 'assets/test.png', 'text': 'Opción 15'},
    {'image': 'assets/test.png', 'text': 'Opción 16'},
    {'image': 'assets/test.png', 'text': 'Opción 17'},
    {'image': 'assets/test.png', 'text': 'Opción 18'},
    {'image': 'assets/test.png', 'text': 'Opción 19'},
    {'image': 'assets/test.png', 'text': 'Opción 20'},
    {'image': 'assets/test.png', 'text': 'Opción 21'},
    {'image': 'assets/test.png', 'text': 'Opción 22'},
    {'image': 'assets/test.png', 'text': 'Opción 23'},
    {'image': 'assets/test.png', 'text': 'Opción 24'},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Botones en grilla')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                color: Colors.deepPurple.withOpacity(0.2), // Color de ejemplo
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.volume_up, color: Colors.black),
                    Icon(Icons.play_circle_fill, color: Colors.deepPurple),
                    Icon(Icons.settings, color: Colors.black),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return RectangularButton(
                      imagePath: item['image']!,
                      text: item['text']!,
                      selected: selectedList[index],
                      onPressed: () {
                        setState(() {
                          selectedList[index] = !selectedList[index];
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RectangularButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onPressed;
  final bool selected;

  const RectangularButton({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.onPressed,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: selected ? Colors.purple : Colors.white,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Image.asset(imagePath, fit: BoxFit.contain)),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
