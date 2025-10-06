import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notificationlist extends StatelessWidget{

    final List<DateTime> horarios;
    final String text;
    final void Function(DateTime) onDelete;

  const Notificationlist({super.key, required this.horarios, required this.text,required  this.onDelete});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.Hm(); // 24h → "08:30"
    // si prefieres 12h usa: DateFormat.jm(); → "8:30 AM"
    print("tamaño de la lista " + horarios.length.toString());
    return Column(
      children: [
        Text(text),
        ListView.builder(
          shrinkWrap: true, // importante si está dentro de otra vista scrollable
          itemCount: horarios.length,
          itemBuilder: (context, index) {
            final horario = horarios[index];
            return ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(formatter.format(horario)),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => onDelete(horario),
              ),
            );
          },
        ),
      ],
    );
  }
}