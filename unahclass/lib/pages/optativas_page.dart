import 'package:flutter/material.dart';

class OptativasScreen extends StatelessWidget {
  const OptativasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('clases del periodo')),
      body: const Center(child: Text(':)', style: TextStyle(fontSize: 24))),
    );
  }
}
