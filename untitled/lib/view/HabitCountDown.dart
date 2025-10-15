import 'package:flutter/material.dart';
import 'package:untitled/ViewModel/CountDownVM.dart';
import 'package:untitled/componentes/BotonApp.dart';
import 'package:untitled/componentes/timerAnim.dart';
import 'package:untitled/model/hiveObjects/Habit.dart';
import 'package:provider/provider.dart';
import 'package:untitled/repos/NotiRepo.dart';

class HabitCountdown extends StatefulWidget {
  const HabitCountdown({super.key,required this.habit, required  this.onFinish, required this.notiRepo});
  final Habit habit;
  final VoidCallback? onFinish;
  final NotiRepo? notiRepo;


  @override
  State<HabitCountdown> createState() => _HabitCountdownState();
}

class _HabitCountdownState extends State<HabitCountdown> {

  late Countdownvm vm;

  @override
  void initState() {
    super.initState();
    vm = Provider.of<Countdownvm>(context,listen: false);
    vm.startTimer(widget.habit.progress.timeToCompleteHabit!*60,onComplete:widget.onFinish,notiRepo:widget.notiRepo 
    ); // arranca el timer solo 1 vez
  }


  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nombre habito?'),
          automaticallyImplyLeading: false,
          elevation: 4,
          backgroundColor: Colors.purple.shade100,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Consumer<Countdownvm>(
              builder: (context, vm, child) {
                return TimerAnim(
                  percent: vm.timePercent,
                  timeText: vm.timeText,
                );
              },
            ),
              Expanded(child: Container()),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BotonApp(texto: "Cancelar", onPressed: () {
                         vm.cancelTimer();
                         Navigator.pop(context); 
                         }),
                      BotonApp(texto: "Terminado", onPressed: () {
                        //vm.remainingSeconds = 0;
                        vm.terminarTimer();
                        
                      }),
                        Consumer<Countdownvm>(
                          builder: (context, vm, child) {
                            return BotonApp(texto: (vm.paused)?"Continuar":"Pausa", onPressed: () { 
                            vm.pauseTimer();
                          });
                          },
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          )
        ),
      ),
    );
  }
}