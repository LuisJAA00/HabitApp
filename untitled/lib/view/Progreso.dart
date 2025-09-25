import 'package:flutter/material.dart';
import 'package:untitled/services/DBservice.dart';
import '../services/notiService.dart';


import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Progreso extends StatelessWidget {
  const Progreso({super.key});

  void _cancelarTodasLasNotificaciones(BuildContext context) async {
    await Notiservice.instance.flutterLocalNotificationsPlugin.cancelAll();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Todas las notificaciones fueron eliminadas'),
      ),
    );
  }
  void _eliminarTodosLosHabitos(BuildContext context) async {

  final box = DBHelper.instance.habitBox;
  await box.clear();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('🗑️ Todos los hábitos fueron eliminados'),
    ),
  );
}

  void _mostrarNotificacionesPendientes(BuildContext context) async {
    final plugin = Notiservice.instance.flutterLocalNotificationsPlugin;
    final List<PendingNotificationRequest> pendientes =
      await plugin.pendingNotificationRequests();

    if (pendientes.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('🔕 Sin notificaciones'),
          content: const Text('No hay notificaciones pendientes.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🔔 Notificaciones activas'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pendientes.length,
            itemBuilder: (_, index) {
              final n = pendientes[index];
              return ListTile(
                title: Text(n.title ?? 'Sin título'),
                subtitle: Text(n.body ?? 'Sin cuerpo'),
                trailing: Text('ID: ${n.id}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progreso'),
        elevation: 4,
        backgroundColor: Colors.purple.shade100,
      ),
      body: const Center(
        child: Text('Esta es la pantalla de progreso'),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _mostrarNotificacionesPendientes(context),
            label: const Text('Ver notificaciones'),
            icon: const Icon(Icons.notifications),
            backgroundColor: Colors.blue,
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            onPressed: () => _cancelarTodasLasNotificaciones(context),
            label: const Text('Borrar notificaciones'),
            icon: const Icon(Icons.delete_forever),
            backgroundColor: Colors.redAccent,
          ),
          const SizedBox(height: 12),
FloatingActionButton.extended(
  onPressed: () => _eliminarTodosLosHabitos(context),
  label: const Text('Borrar hábitos'),
  icon: const Icon(Icons.cleaning_services),
  backgroundColor: Colors.deepOrange,
),

        ],
      ),
    );
  }
}
