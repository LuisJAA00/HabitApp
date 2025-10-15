
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:untitled/componentes/BotonApp.dart';
import 'package:untitled/componentes/NotificationList.dart';

import 'package:untitled/componentes/notificationCard.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/model/hiveObjects/Habit.dart';

import '../ViewModel/AddViewModel.dart';

class Add extends StatelessWidget {
  final Habit? existingHabit;

  const Add({super.key, this.existingHabit});

  Widget buildHabitCard(BuildContext context, String daysText, DateTime time) {

    final vm = Provider.of<AddViewModel>(context);

    return NotificationCard(
      daysText: daysText, 
      time: TimeOfDay(hour: time.hour, minute: time.minute), 
      onDelete: () => vm.deleteNot(time)
      );
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final vm = Provider.of<AddViewModel>(context);


    // Solo inicializa si es necesario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.existingHabit == null && existingHabit != null) {
        vm.init(existingHabit);
        print("inicializando existing habit");
      }
    });

    //List<Widget> notificationCards = [];



    return Scaffold(
      appBar: AppBar(
        title: Text(texts.addTitle),
        backgroundColor: Colors.purple.shade100,
        elevation: 4,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: vm.formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: vm.titleController,
                decoration: InputDecoration(labelText: texts.habitName),
                onChanged: vm.setTitle,
                //initialValue: vm.title,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "El hábito debe tener nombre";
                  }
                  if(int.tryParse(value.trim()) != null)//es un numero
                  {
                    return "El titulo no puede ser un número";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SwitchListTile(
                title: Text(texts.needTimer),
                value: vm.usesTimer,
                onChanged: vm.toggleUsesTimer,
              ),
              if (vm.usesTimer)
                Row(
                  children: [
                    Text("Duración: "),
                    DropdownButton<int>(
                      value: vm.duration.inMinutes,
                      items: [5, 10, 15, 20, 30].map((min) {
                        return DropdownMenuItem(
                          value: min,
                          child: Text("$min min"),
                        );
                      }).toList(),
                      onChanged: (min) {
                        if (min != null){ vm.setDuration(min);}
                       
                      },
                    ),
                  ],
                ),

              const SizedBox(height: 30),


              DropdownButtonFormField<String>(
                value: vm.frequency,
                decoration: InputDecoration(labelText: texts.frequency),
                items: [
                  DropdownMenuItem(value: 'diario', child: Text(texts.daily)),
                  DropdownMenuItem(
                    value: 'diasEspecificos',
                    child: Text(texts.selectDays),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) vm.setFrequency(value);
                },
              ),

              if (vm.frequency == 'diario')
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${vm.goalPerDay} ${vm.goalPerDay == 1 ? texts.vez : texts.veces} ${texts.aDay}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: BotonApp(
                        texto: "-",
                        onPressed: vm.decrementGoalPerDay,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 1,
                      child: BotonApp(
                        texto: "+",
                        onPressed: vm.incrementGoalPerDay,
                      ),
                    ),
                  ],
                ),
              if (vm.frequency == 'xPorSemana')
                TextFormField(
                  decoration: const InputDecoration(labelText: "Veces por semana"),
                  keyboardType: TextInputType.number,
                  initialValue: vm.goalPerWeek.toString(),
                  onChanged: (value) => vm.setGoalPerWeek(int.tryParse(value) ?? 1),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return texts.valorValido;
                    }
                    final parsed = int.tryParse(value);
                    if (parsed == null) return texts.numeroValido;
                    if (parsed < 1 || parsed > 7) return texts.between17;
                    return null;
                  },
                ),
              if (vm.frequency == 'diasEspecificos')
                FormField<List<bool>>(
                  initialValue: vm.selectedDays,
                  validator: (value) {
                    if (value == null || !value.contains(true)) {
                      return texts.select1Day;
                    }
                    return null;
                  },
                  builder: (state) {
                    var days = [
                      texts.l,
                      texts.m,
                      texts.mi,
                      texts.j,
                      texts.v,
                      texts.s,
                      texts.d,
                    ];
                    return Column(
                      children: [
                        Wrap(
                          spacing: 8,
                          children: List.generate(7, (i) {
                            final selected = vm.selectedDays[i];
                            return GestureDetector(
                              onTap: () {
                                vm.toggleDay(i);
                                state.didChange(vm.selectedDays);
                              },
                              child: Container(
                                width: 46,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: selected ? Color(0xFF7F52BE) : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: selected ? Color(0xFF7F52BE) : Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  days[i],
                                  style: TextStyle(
                                    color: selected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    );
                  },
                ),

              CheckboxListTile(
                title: Text(texts.enableReminder),
                value: vm.isReminderEnable,
                onChanged: (v) => vm.toggleReminder(v ?? true),
              ),

              //if(vm.isReminderEnable)
              //SwitchListTile(
              //  title: Text("Noticiaciones personalizadas"),
              //  value: vm.persNot,
              //  onChanged: vm.togglePersNot,
              //),
              


              if (vm.isReminderEnable)
                BotonApp(
                  texto: "Agregar notificación",
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                          child: Localizations.override(
                            context: context,
                            locale: const Locale('en', 'US'), // Override locale to ensure AM/PM format
                            child: child!,
                          ),
                        );
                      },
                    );
                    if (picked != null) 
                    {
                      vm.setTime(picked);

                    }
                  },
                ),

              const SizedBox(height: 40),
              
              if(vm.existingHabit != null && vm.isReminderEnable)
                Notificationlist(text: "Notificaciones actuales",horarios: vm.existingHabit!.reminder.horarios, onDelete: 
                (horario)
                {
                  vm.removeExistingTime(horario);
                },),
      
              const SizedBox(height: 40),

              if(vm.selectedTime.isNotEmpty && vm.isReminderEnable)
                Consumer<AddViewModel>(
                  builder: (context, vm, child){
                    return Notificationlist(horarios: vm.selectedTime, text: "Nuevas notificaciones",onDelete: (horario) {
                      vm.removeTime(horario);
                    },);
                  }
                ),
                
              /*  Consumer<AddViewModel>(
                builder: (context, vm, child)
                {
                  final times = vm.selectedTime;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: times.length,
                    itemBuilder: (context, index) {
                      final time = times[index];
                      return Text(time.toString());//Text(vm.frequency + " " + time.hour.toString() + " " + time.minute.toString());
                    },
                  );
                }
                ), */
              


              const SizedBox(height: 40),

              BotonApp(
                texto: texts.save,
                onPressed: () async {
                  if (!vm.formKey.currentState!.validate()) return;

                  final habit = vm.toHabit();

                  if (vm.existingHabit != null) { // editing an habit
                   // if(await vm.nameInUse(vm.titleController.text.trim()))
                   // {
                   //   ScaffoldMessenger.of(context).showSnackBar(
                   //   SnackBar(content: Text(texts.nameAlreadyInUse)),
                   //   );
                   //   return;
                   // }
                    print("Guardando habito editado");
                    vm.generateEditHabit(habit,vm.existingHabit!,vm.selectedTime);

                    vm.restartVM();

                  } else {
                    if(await vm.nameInUse(vm.titleController.text.trim()))
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(texts.nameAlreadyInUse)),
                      );
                      return;
                    }

                    if(vm.selectedTime.isEmpty)
                    {
                      vm.setTime(TimeOfDay.now());
                    }

                    vm.saveHabit(habit,vm.selectedTime);
                    vm.restartVM();
                   

                  }

                  String finText = "";
                  if(vm.existingHabit != null){
                    finText = "Habito editado correctamente";
                  }
                  else{
                    finText = texts.habitCreated;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(finText)),
                  );
                 
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
