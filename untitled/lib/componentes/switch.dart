import 'package:flutter/material.dart';


class SwitchCustom extends StatelessWidget {
  final bool isSwitch; // valor que viene del ViewModel
  final ValueChanged<bool> onToggle; // callback para actualizar el estado

  const SwitchCustom({
    super.key,
    required this.isSwitch,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Switch(
        value: isSwitch,
        onChanged: (value) => onToggle(value), // llama a tu ViewModel
      ),
    );
  }
}