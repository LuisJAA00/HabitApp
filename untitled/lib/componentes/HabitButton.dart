import 'package:flutter/material.dart';

class HabitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HabitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 127, 82, 190),
        foregroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Colors.grey),
        ),
      ),
      child: const Text("Hecho"),
    );
  }
}
