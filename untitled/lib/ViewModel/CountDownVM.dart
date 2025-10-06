import 'dart:async';

import 'package:flutter/material.dart';

class Countdownvm extends ChangeNotifier{
  int totalSeconds =0; // duración total en segundos
  int remainingSeconds = 0;   // tiempo restante
  Timer? _timer;
  bool paused = false;

  /// Inicia el temporizador
  void startTimer(int time,{required VoidCallback? onComplete}) {
    // Evita crear múltiples timers
    _timer?.cancel();
    remainingSeconds = time;
    totalSeconds = time;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      
      if(paused){return;}

      if (remainingSeconds > 0) {
        remainingSeconds--;
        print(remainingSeconds);
        notifyListeners(); // notifica a la UI
      } else {
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

  /// Reiniciar el timer
  void resetTimer() {
    _timer?.cancel();
    paused = false;
    remainingSeconds = totalSeconds;
    notifyListeners();
  }

  /// Porcentaje completado (0.0 a 1.0)
  double get timePercent {
    final percent = 1 - (remainingSeconds / totalSeconds);
    print("percent " + percent.toString());
    return percent;
  }

  /// Formato de tiempo "MM:SS"
  String get timeText {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}