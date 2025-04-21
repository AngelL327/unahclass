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