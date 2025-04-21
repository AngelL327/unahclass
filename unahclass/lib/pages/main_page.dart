import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HACER EL REGISTRO ')),
      body: const Center(
        child: Text('REGISTRO ', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
