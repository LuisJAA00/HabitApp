import 'package:flutter/material.dart';
import 'package:untitled/model/HabitBase.dart';

class HabitDetailPage extends StatelessWidget {
  final Habitbase habit;

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
      if (habit.daysTodoHabit[i] == 1) {
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
              "Fecha de inicio: ${habit.lastDateDone.day}/${habit.lastDateDone.month}/${habit.lastDateDone.year}",
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
                "Temporizador: ${habit.timeToCompleteHabit} minutos",
              ),
            if (habit.usesTimer == false) Text("Sin temporizador " + habit.progress.timeToCompleteHabit!.toString()),

            
       //     if (habit.reminder?.enable == true) ...[
         //     Text("Notificaciones activas a las:"),
           //   ...habit.reminder!.time!.map((t) => Text(
             // "${t.hour} hrs ${t.minute} min",
              //style: TextStyle(fontSize: 16),
              //)),
              //],

              
            if (habit.reminder?.enable == false)
              Text("Sin notificaciones programadas"),
            // Puedes agregar más información aquí
          ],
        ),
      ),
    );
  }
}
