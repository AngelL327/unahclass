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
        itemBuilder:
            (context, index) =>
                _buildCarreraCard(context, carreras[index], index),
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

class CarreraDetailScreen extends StatelessWidget {
  final String carreraNombre;

  const CarreraDetailScreen({super.key, required this.carreraNombre});

  bool _tieneElementosEspeciales() {
    final optativas = CarrerasData.getOptativasPorCarrera(carreraNombre);
    final laboratorios = CarrerasData.getLaboratoriosPorCarrera(carreraNombre);
    final orientaciones = CarrerasData.getOrientacionesPorCarrera(
      carreraNombre,
    );
    final electivos = CarrerasData.getEspaciosAprendizajeElectivos(
      carreraNombre,
    );

    return optativas.isNotEmpty ||
        laboratorios.isNotEmpty ||
        orientaciones.isNotEmpty ||
        electivos != null;
  }

  @override
  Widget build(BuildContext context) {
    final periodos = CarrerasData.getPeriodosUnicos(carreraNombre);
    final mostrarBotonEspeciales = _tieneElementosEspeciales();

    return Scaffold(
      appBar: AppBar(
        title: Text(carreraNombre),
        backgroundColor: const Color(0xFF1D9FCB),
        foregroundColor: Colors.white,
        actions: [
          if (mostrarBotonEspeciales)
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 219, 217, 212),
              ),
              tooltip: 'Elementos especiales',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ElementosEspecialesScreen(
                          carreraNombre: carreraNombre,
                        ),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Periodos Académicos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          _buildPeriodosList(periodos, carreraNombre),
        ],
      ),
    );
  }

  Widget _buildPeriodosList(List<String> periodos, String carreraNombre) {
    if (periodos.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'No hay periodos disponibles',
            style: TextStyle(fontSize: 16, color: Colors.blueGrey),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            periodos.map((periodo) {
              final materias = CarrerasData.getMateriasPorPeriodo(
                carreraNombre,
                periodo,
              );
              return PeriodoContainer(periodo: periodo, materias: materias);
            }).toList(),
      ),
    );
  }
}

class ElementosEspecialesScreen extends StatelessWidget {
  final String carreraNombre;

  const ElementosEspecialesScreen({super.key, required this.carreraNombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elementos Especiales - $carreraNombre'),
        backgroundColor: const Color(0xFF1D9FCB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSeccionOptativas(),
            _buildSeccionLaboratorios(),
            _buildSeccionOrientaciones(),
            _buildSeccionElectivos(),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionOptativas() {
    final optativas = CarrerasData.getOptativasPorCarrera(carreraNombre);
    if (optativas.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Materias Optativas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...optativas.map((materia) => _buildTarjetaMateria(materia)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSeccionLaboratorios() {
    final laboratorios = CarrerasData.getLaboratoriosPorCarrera(carreraNombre);
    if (laboratorios.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Laboratorios',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...laboratorios.map(
          (lab) => Card(
            child: ListTile(
              leading: const Icon(Icons.science),
              title: Text(lab['asignatura'] ?? 'Laboratorio'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Código: ${lab['codigo'] ?? ''}"),
                  Text("Espacio: ${lab['Espacio de Aprendizaje'] ?? ''}"),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSeccionOrientaciones() {
    final orientaciones = CarrerasData.getOrientacionesPorCarrera(
      carreraNombre,
    );
    if (orientaciones.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Orientaciones',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...orientaciones.map(
          (orientacion) => ExpansionTile(
            title: Text(orientacion['nombre'] ?? 'Orientación'),
            children:
                CarrerasData.getMateriasPorOrientacion(
                  carreraNombre,
                  orientacion['nombre'],
                ).map((materia) => _buildTarjetaMateria(materia)).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSeccionElectivos() {
    final electivos = CarrerasData.getEspaciosAprendizajeElectivos(
      carreraNombre,
    );
    if (electivos == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Espacios Electivos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...electivos.entries.map(
          (entry) => ExpansionTile(
            title: Text(entry.key),
            children:
                entry.value
                    .map((materia) => _buildTarjetaMateria(materia))
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTarjetaMateria(Map<String, dynamic> materia) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(materia['asignatura'] ?? 'Sin nombre'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Código: ${materia['codigo'] ?? 'N/A'}"),
            if (materia['uv'] != null) Text("UV: ${materia['uv']}"),
          ],
        ),
        trailing: Text("Req: ${materia['requisito'] ?? 'Ninguno'}"),
      ),
    );
  }
    
}
