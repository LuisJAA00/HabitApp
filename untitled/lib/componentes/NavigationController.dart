import 'package:flutter/material.dart';

// Controlador global para manejar el índice de la pestaña activa.
class NavigationController {
  static final ValueNotifier<int> tabIndex = ValueNotifier<int>(
    1,
  ); // default a Home
}
