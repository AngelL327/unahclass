import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del usuario')),
      body: const Center(child: Text(':)', style: TextStyle(fontSize: 24))),
    );
  }
}
