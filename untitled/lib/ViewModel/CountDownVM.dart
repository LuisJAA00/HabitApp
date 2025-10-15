import 'dart:async';

import 'package:flutter/material.dart';
import 'package:untitled/repos/NotiRepo.dart';

class Countdownvm extends ChangeNotifier{
  int totalSeconds =0; // duración total en segundos
  int remainingSeconds = 0;   // tiempo restante
  Timer? _timer;
  bool paused = false;
  int pausedSeconds = 0;
  bool _terminado = false;
  NotiRepo? notiRepo;

  /// Inicia el temporizador
  void startTimer(int time,{required VoidCallback? onComplete, required NotiRepo? notiRepo}) {
    // Evita crear múltiples timers
    time += 1; // por desfase
    final now = DateTime.now();
    final dur = Duration(seconds: time);
    final end = now.add(dur);
    
    //print("time "+time.toString() + " now " + now.toString() + " end " + end.toString());

    _timer?.cancel();
    remainingSeconds = end.difference(now).inSeconds; //inicio normal
    //print("remain start " + remainingSeconds.toString());

    totalSeconds = time;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      
      if(paused){
        pausedSeconds += 1;
        return;
        }

      if (remainingSeconds > 0) {
        //remainingSeconds--;
        //actualizar segundos restantes
        
        //remainingSeconds = DateTime.now().difference(end.add(Duration(seconds: pausedSeconds))).inSeconds.abs();
        remainingSeconds = end
        .add(Duration(seconds: pausedSeconds))
        .difference(DateTime.now())
        .inSeconds;

        if (remainingSeconds < 0) {remainingSeconds = 0; }

        print(remainingSeconds);
        print("terminado estado? " + _terminado.toString());
        notifyListeners(); // notifica a la UI
      } else {
        print("terminado " + _terminado.toString());
        if(_terminado == false)
        {
          notiRepo!.instantAlarm();
        }
        
        _timer?.cancel();
        remainingSeconds = 0;
        notifyListeners(); 
        if (onComplete != null) {
          onComplete();
        }
      }
    });

    
  }

  /// Pausar el timer
  void pauseTimer() {
    paused = !paused;
    notifyListeners();
  }

  void terminarTimer() {
    remainingSeconds = 0;
    _terminado = true;
  }

  /// Reiniciar el timer
  void resetTimer() {
    _timer?.cancel();
    paused = false;
    remainingSeconds = totalSeconds;
    notifyListeners();
  }

  /// Porcentaje completado (0.0 a 1.0)
  double get timePercent {
    //print("remain "+remainingSeconds.toString());
    //print("total "+totalSeconds.toString());
    final percent = 1 - (remainingSeconds / totalSeconds);
    //print("percent " + percent.toString());
    return percent;
  }

  void cancelTimer()
  {
    _timer?.cancel();
  }

  /// Formato de tiempo "MM:SS"
  String get timeText {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}