import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HACER EL INICIO DE SECION ')),
      body: const Center(
        child: Text('INICIO DE SECION ', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
