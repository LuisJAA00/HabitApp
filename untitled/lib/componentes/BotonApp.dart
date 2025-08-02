import 'package:flutter/material.dart';

class BotonApp extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const BotonApp({super.key, required this.texto, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 127, 82, 190),
          foregroundColor: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: Colors.grey),
          ),
        ),
        onPressed: onPressed,
        child: Text(texto),
      ),
    );
  }
}
