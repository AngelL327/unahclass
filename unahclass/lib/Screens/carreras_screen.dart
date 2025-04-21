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
    Widget _buildCarreraCard(BuildContext context, String carrera, int index) {
    final colors = [
      [const Color(0xFF05D1AC), const Color(0xFF05D1AC)], // Verde agua
      [const Color(0xFFE94409), const Color(0xFFE94409)], // Rojo/naranja fuerte
      [const Color(0xFFE20F83), const Color(0xFFE20F83)], // Fucsia fuerte
      [const Color(0xFF0D5BDA), const Color(0xFF0D5BDA)], // Azul profundo
      [const Color(0xFF13E05E), const Color(0xFF13E05E)], // Verde brillante
    ];
    final gradientColors = colors[index % colors.length];

    return GestureDetector(
      onTap: () => _navigateToCarreraDetail(context, carrera),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        child: Text(
          carrera,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _navigateToCarreraDetail(BuildContext context, String carreraNombre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarreraDetailScreen(carreraNombre: carreraNombre),
      ),
    );
  }
}