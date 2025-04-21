import 'package:flutter/material.dart';
import 'package:unahclass/widgets/helper.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _resetAllData(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('¿Restablecer todo?'),
            content: const Text(
              'Esta accion borrara todos tus datos y configuracion locales. ¿Continuar?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Restablecer',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await UserPrefs.clearAllUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos restablecidos correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Ajustes de la App", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _resetAllData(context),
              icon: const Icon(Icons.restart_alt, color: Colors.white),
              label: const Text(
                'RESTABLECER TODO',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Esta accion no se puede deshacer',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
