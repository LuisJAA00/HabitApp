import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/componentes/HabitCard.dart';
import 'package:untitled/model/Habit.dart';
import '../l10n/app_localizations.dart';
import '../ViewModel/HomeViewModel.dart';
class Home extends StatelessWidget {
  const Home({super.key});

  Widget buildHabitCard(BuildContext context, Habit habit, {bool isDone = false}) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);

    return Habitcard(
      isActive: false,
      onDone: () => viewModel.habitDone(habit),       
      onStart: () {},
      onPause: () {},
      onFinish: () {},
      habit: habit,
      onDelete: () => viewModel.deleteHabit(habit),
      onEdit: () => viewModel.editHabit(habit, context),       
    );
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final viewModel = Provider.of<HomeViewModel>(context);

    String getDayName(int index) {
      var days = [
        texts.lunes,
        texts.martes,
        texts.miercoles,
        texts.jueves,
        texts.viernes,
        texts.sabado,
        texts.domingo,
      ];
      return days[index];
    }

    if (viewModel.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          elevation: 4,
          backgroundColor: Colors.purple.shade100,
        ),
        body: Center(child: Text(texts.noHabitsYet)),
      );
    }

    final List<Widget> sections = [];

    if (viewModel.paraHoy.isNotEmpty) {
      sections.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            texts.forToday,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
      for (var habit in viewModel.paraHoy) {
        sections.add(buildHabitCard(context, habit));
      }
    }

    if (viewModel.proximosDias.isNotEmpty) {
      final sortedKeys = viewModel.proximosDias.keys.toList()..sort();
      for (var day in sortedKeys) {
        final diaString = getDayName(day);
        sections.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${texts.proximo}: $diaString",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
        for (var habit in viewModel.proximosDias[day]!) {
          sections.add(buildHabitCard(context, habit));
        }
      }
    }

    if (viewModel.yaRealizados.isNotEmpty) {
      sections.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            texts.hecho,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
      for (var habit in viewModel.yaRealizados) {
        sections.add(buildHabitCard(context, habit, isDone: true));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 4,
        backgroundColor: Colors.purple.shade100,
      ),
      body: ListView(children: sections),
    );
  }
}
