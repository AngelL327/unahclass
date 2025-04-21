import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:unahclass/optativas_de_opt_page/materias_por_periodo_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:unahclass/widgets/helper.dart';

class DetalleCarreraScreen extends StatefulWidget {
  @override
  _DetalleCarreraScreenState createState() => _DetalleCarreraScreenState();
}

class _DetalleCarreraScreenState extends State<DetalleCarreraScreen> {
  Map<String, dynamic>? carreraSeleccionada;
  Set<String> materiasSeleccionadas = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    

    // Cargar carrera
    String? carreraString = await UserPrefs.getString('carreraSeleccionada');
    if (carreraString != null) {
      Map<String, dynamic> carreraMap = json.decode(carreraString);
      setState(() {
        carreraSeleccionada = carreraMap;
      });
    }

    // Cargar materias seleccionadas
    List<String>? seleccionadas = await UserPrefs.getStringList('materiasSeleccionadas');
    setState(() {
      materiasSeleccionadas = seleccionadas?.toSet() ?? {};
    });
  }

  Future<void> _actualizarMateriasSeleccionadas() async {
    List<String>? seleccionadas = await UserPrefs.getStringList('materiasSeleccionadas');
    setState(() {
      materiasSeleccionadas = seleccionadas?.toSet() ?? {};
    });
  }

  @override
  Widget build(BuildContext context) {
    if (carreraSeleccionada == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          carreraSeleccionada!['carrera'],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1d9fcb),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          padding: const EdgeInsets.only(top: 18),
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          children: _buildPeriodosCards(),
        ),
      ),
    );
  }

  List<Widget> _buildPeriodosCards() {
    Map<String, List<Map<String, dynamic>>> materiasPorPeriodo = {};

    for (var materia in carreraSeleccionada!['materias']) {
      String periodo = materia['periodo']?.toString() ?? 'Sin periodo';
      if (periodo.isNotEmpty && periodo != 'Sin periodo') {
        materiasPorPeriodo.putIfAbsent(periodo, () => []).add(materia);
      }
    }

    return materiasPorPeriodo.entries.map((entry) {
      final periodo = entry.key;
      final materias = entry.value;

      int total = materias.length;
      int completadas = materias.where((m) => materiasSeleccionadas.contains(m['codigo'])).length;
      double porcentaje = total == 0 ? 0 : completadas / total;

      return GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MateriasPorPeriodoScreen(
                materias: materias,
                nombrePeriodo: "PERIODO $periodo",
              ),
            ),
          );
          await _actualizarMateriasSeleccionadas(); // <-- Recarga al volver
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Color(0xFF1d9fcb),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                left: 8,
                child: CircularPercentIndicator(
                  radius: 30.0,  // Tamaño reducido de la barra circular
                  lineWidth: 6.0, // Ancho de la barra
                  percent: porcentaje,
                  center: Text('${(porcentaje * 100).toInt()}%', style: TextStyle(color: Colors.white)),
                  progressColor: Colors.white,
                  backgroundColor: Colors.white24,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
              Positioned(
                bottom: 12,  // Posiciona más abajo
                left: 0,
                right: 0,
                child: Text(
                  "Periodo $periodo", // Texto más pequeño
                  style: TextStyle(
                    fontSize: 10,  // Tamaño de letra más pequeño
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center, // Centrado
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}