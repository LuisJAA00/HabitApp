import 'package:flutter/material.dart';

import 'package:untitled/model/HabitBase.dart';
import 'HabitButton.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../view/HabitDetailPage.dart'; // Asume que creas esta pantalla

class Habitcard extends StatefulWidget {
  final bool isActive;
  final Duration? timeLeft;
  final VoidCallback onDone;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onFinish;
  final Habitbase habit;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const Habitcard({
    super.key,
    required this.isActive,
    this.timeLeft,
    required this.onDone,
    required this.onStart,
    required this.onPause,
    required this.onFinish,
    required this.habit,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<Habitcard> createState() => _HabitcardState();
}

class _HabitcardState extends State<Habitcard> {
  bool isDone = false;


  @override
  Widget build(BuildContext context) {
    Widget next2ButtonIcon;

    


    if (widget.habit.usesTimer) {
      next2ButtonIcon = Container(
        padding: EdgeInsets.all(4),
        child: Icon(Icons.timer_sharp),
      );
    } else {
      next2ButtonIcon = SizedBox.shrink();
    }

    return Slidable(
      key: ValueKey(widget.habit.key),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          CustomSlidableAction(
            padding: EdgeInsets.all(2),
            onPressed:(_) => widget.onEdit(),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Editar", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          CustomSlidableAction(
            padding: EdgeInsets.all(2),
            onPressed: (_) => widget.onDelete(),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Eliminar", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
      child: Opacity(
        opacity: (widget.habit.progress.vecesCompletado == widget.habit.reminder.horarios.length)//(widget.habit.lastDateDone.day == DateTime.now().day)
            ? 0.4
            : 1.0,
        child: SizedBox(
          height: 120,
          width: double.infinity,
          child: Card(
            color: isDone ? Colors.green : Colors.white,
            margin: const EdgeInsets.all(8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HabitDetailPage(habit: widget.habit),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.habit.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (widget.habit.usesTimer)
                                ? "Minutos hechos: ${widget.habit.minutesCompleted}"
                                : "Acumulado: ${widget.habit.progress.totalCompletions}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 97, 97, 97),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HabitButton(
                        
                        onPressed: widget.onDone,
                      ),
                    ),

                    next2ButtonIcon,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
