import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TimerAnim extends StatelessWidget {
  final double percent;     // porcentaje completado, entre 0 y 1
  final String timeText;    // texto del tiempo que quieres mostrar

  const TimerAnim({
    super.key,
    required this.percent,
    required this.timeText,
  });


  @override
  Widget build(BuildContext context) {

    
    return CircularPercentIndicator(
      radius: 200,
      lineWidth: 20,
      percent: percent, // porcentaje completado
      progressColor: Colors.deepPurple,
      backgroundColor: Colors.deepPurple.shade100,
      circularStrokeCap: CircularStrokeCap.round,
      center:  Text( 
        timeText,
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }
}
