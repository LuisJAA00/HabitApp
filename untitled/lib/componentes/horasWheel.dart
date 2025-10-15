import 'package:flutter/material.dart';

class HorasWheel extends StatefulWidget{
  const HorasWheel({Key? key}) : super(key: key);

  @override
  _HorasWheelState createState() => _HorasWheelState();

}

class _HorasWheelState extends State<HorasWheel> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: ListWheelScrollView(itemExtent: 50, 
        children: [
          Container(
            child: Text("Hello"),
          )
        ]),
      );
  }
}