import 'package:flutter/material.dart';
import '../model/Habit.dart';

class HabitDetailPage extends StatelessWidget {
  final Habit habit;

  const HabitDetailPage({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    String frecuencia = "";
    List<String> dias = [];
    List<String> diasSemana = [
      "Lunes", // 0
      "Martes", // 1
      "Miercoles", // 2
      "Jueves", // 3
      "Viernes", // 4
      "Sabado", // 5
      "Domingo", // 6
    ];

    for (int i = 0; i < 7; i++) {
      if (habit.progress.daysTodoHabit[i] == 1) {
        dias.add("${diasSemana[i]}");
      }
    }

    switch (habit.frecuency) {
      case "diasEspecificos":
        frecuencia = "Días seleccionados";
        break;
      case "diario":
        frecuencia = "Todos los días";
        break;
      case "xPorSemana":
        frecuencia = "Número se veces por semana";
        break;
    }

    return Scaffold(
      appBar: AppBar(title: Text(habit.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fecha de inicio: ${habit.progress.startedAt?.day}/${habit.progress.startedAt?.month}/${habit.progress.startedAt?.year}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),

            Text("Frecuencia: $frecuencia", style: TextStyle(fontSize: 16)),
            if (habit.frecuency == "diasEspecificos")
              Text(
                "Días en los que debe ser realizado el habito: ${dias.join(", ")}",
              ),

            if (habit.usesTimer)
              Text(
                "Temporizador: ${habit.progress.timeToCompleteHabit} minutos",
              ),
            if (habit.usesTimer == false) Text("Sin temporizador"),

            if (habit.reminder?.enable == true && habit.reminder!.time != null)
              Text(
                "Notificaciones activas a las: ${habit.reminder?.time?.hour} hrs ${habit.reminder?.time?.minute} mts",
              ),

            if (habit.reminder?.enable == false)
              Text("Sin notificaciones programadas"),
            // Puedes agregar más información aquí
          ],
        ),
      ),
    );
  }
}
