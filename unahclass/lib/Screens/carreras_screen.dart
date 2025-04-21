import 'package:flutter/material.dart';
import 'package:unahclass/data/carreras_data.dart';
import 'package:unahclass/widgets/periodo_container.dart';

class CarrerasScreen extends StatelessWidget {
  final String facultad;

  const CarrerasScreen({super.key, required this.facultad});

  @override
  Widget build(BuildContext context) {
    final carreras = CarrerasData.getCarrerasPorFacultad(facultad);

    return Scaffold(
      appBar: AppBar(
        title: Text(facultad),
        backgroundColor: const Color(0xFF1D9FCB),
        foregroundColor: Colors.white,
      ),
      body: _buildBody(carreras),
    );
  }
  Widget _buildBody(List<String> carreras) {
    if (carreras.isEmpty) {
      return const Center(
        child: Text(
          'No hay carreras disponibles para esta facultad',
          style: TextStyle(fontSize: 16, color: Colors.blueGrey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: carreras.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) => _buildCarreraCard(context, carreras[index], index),
      ),
    );
  }