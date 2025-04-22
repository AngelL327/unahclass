import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart'; // Importar el paquete
import 'package:unahclass/widgets/helper.dart';
import '../data/carreras_data.dart';
class ClasesAprobadasScreen extends StatefulWidget {
  const ClasesAprobadasScreen({super.key});

  @override
  State<ClasesAprobadasScreen> createState() => _ClasesAprobadasScreenState();
}

class _ClasesAprobadasScreenState extends State<ClasesAprobadasScreen>{
  List<Map<String, dynamic>> clasesAprobadasDetalles = [];
  Map<String, dynamic>? carreraSeleccionada;
  double porcentajeAprobado = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
  

    // Cargar carrera seleccionada
    String? carreraString = await UserPrefs.getString('carreraSeleccionada');
    if (carreraString != null) {
      carreraSeleccionada = json.decode(carreraString);
    }

    // Cargar materias aprobadas
    final materiasAprobadas = await UserPrefs.getStringList('materiasSeleccionadas') ?? [];

    _cargarClasesAprobadas(materiasAprobadas);
  }

  void _cargarClasesAprobadas(List<String> materiasAprobadas) {
    List<Map<String, dynamic>> materiasAprobadasDetalles = [];
    int totalMaterias = 0;

    if (carreraSeleccionada != null) {
      final materiasCarrera = carreraSeleccionada!['materias'] as List<dynamic>;
      totalMaterias = materiasCarrera.length;

      for (var materia in materiasCarrera) {
        if (materiasAprobadas.contains(materia['codigo'])) {
          materiasAprobadasDetalles.add(Map<String, dynamic>.from(materia));
        }
      }
    } else {
      Set<String> materiasAgregadas = {};
      for (var carrera in CarrerasData.carreras) {
        for (var materia in carrera['materias']) {
          if (!materiasAgregadas.contains(materia['codigo'])) {
            totalMaterias++;
            materiasAgregadas.add(materia['codigo']);
          }
        }
      }

      materiasAgregadas.clear();

      for (var carrera in CarrerasData.carreras) {
        for (var materia in carrera['materias']) {
          if (materiasAprobadas.contains(materia['codigo']) &&
              !materiasAgregadas.contains(materia['codigo'])) {
            materiasAprobadasDetalles.add(materia);
            materiasAgregadas.add(materia['codigo']);
          }
        }
      }
    }

    setState(() {
      clasesAprobadasDetalles = materiasAprobadasDetalles;
      porcentajeAprobado = totalMaterias > 0
          ? materiasAprobadasDetalles.length / totalMaterias
          : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clases Aprobadas', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1D9FCB),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Center(
              child: const Text(
                'TU PROGRESO',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            LinearPercentIndicator(
              lineHeight: 25,
              percent: porcentajeAprobado.clamp(0, 1),
              center: Text(
                '${(porcentajeAprobado * 100).toInt()}%',
                style: const TextStyle(color: Color(0xFF1D9FCB)),
              ),
              barRadius: const Radius.circular(12),
              backgroundColor: Colors.grey.shade200,
              progressColor: Color(0xFF1D9FCB),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: clasesAprobadasDetalles.isEmpty
                  ? const Center(
                      child: Text(
                        "No hay clases aprobadas aún.",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: clasesAprobadasDetalles.length,
                      itemBuilder: (context, index) {
                        final materia = clasesAprobadasDetalles[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.primaries[index % Colors.primaries.length],
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    title: Text(
                                      materia['asignatura'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      'Código: ${materia['codigo']} | UV: ${materia['uv']} | Requisito: ${materia['requisito']}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
