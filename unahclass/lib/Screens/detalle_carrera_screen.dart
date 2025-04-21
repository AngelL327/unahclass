import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:unahclass/data/carreras_data.dart';
class DetalleCarreraScreen extends StatefulWidget {
  DetalleCarreraScreen(String s);

  @override
  _DetalleCarreraScreenState createState() => _DetalleCarreraScreenState();
}

class _DetalleCarreraScreenState extends State<DetalleCarreraScreen> {
  Map<String, dynamic>? carreraSeleccionada;
  List<String> periodos = [];
  bool showOptativas = false;
  bool showLaboratorios = false;
  bool showOrientaciones = false;

  @override
  void initState() {
    super.initState();
    _cargarCarreraSeleccionada();
  }

  Future<void> _cargarCarreraSeleccionada() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? carreraString = prefs.getString('carreraSeleccionada');
    
    if (carreraString != null) {
      setState(() {
        carreraSeleccionada = json.decode(carreraString);
        // Obtener los periodos únicos de la carrera
        if (carreraSeleccionada != null) {
          periodos = CarrerasData.getPeriodosUnicos(carreraSeleccionada!['carrera']);
        }
      });
    }
  }

  void _salir() {
    Navigator.pop(context);
  }

  Widget _buildMateriaCard(Map<String, dynamic> materia) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(materia['asignatura'] ?? 'Sin nombre'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Código: ${materia['codigo'] ?? 'N/A'}"),
            Text("UV: ${materia['uv']?.toString() ?? 'N/A'}"),
          ],
        ),
        trailing: Text("Req: ${materia['requisito'] ?? 'Ninguno'}"),
      ),
    );
  }

  Widget _buildPeriodosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan de Estudios por Periodos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ...periodos.map((periodo) {
          final materias = CarrerasData.getMateriasPorPeriodo(
            carreraSeleccionada!['carrera'],
            periodo
          );
          
          return ExpansionTile(
            title: Text(
              periodo,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              ...materias.map((materia) => _buildMateriaCard(materia)).toList(),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildOptativasSection() {
    final optativas = CarrerasData.getOptativasPorCarrera(carreraSeleccionada!['carrera']);
    if (optativas.isEmpty) return SizedBox();

    return ExpansionTile(
      title: Text(
        'Materias Optativas',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: showOptativas,
      onExpansionChanged: (expanded) => setState(() => showOptativas = expanded),
      children: [
        ...optativas.map((optativa) => _buildMateriaCard(optativa)).toList(),
      ],
    );
  }

  Widget _buildLaboratoriosSection() {
    final laboratorios = CarrerasData.getLaboratoriosPorCarrera(carreraSeleccionada!['carrera']);
    if (laboratorios.isEmpty) return SizedBox();

    return ExpansionTile(
      title: Text(
        'Laboratorios',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: showLaboratorios,
      onExpansionChanged: (expanded) => setState(() => showLaboratorios = expanded),
      children: [
        ...laboratorios.map((lab) => Card(
          child: ListTile(
            title: Text(lab['asignatura'] ?? 'Laboratorio'),
            subtitle: Text("Código: ${lab['codigo'] ?? ''}"),
            trailing: Text("Espacio: ${lab['Espacio de Aprendizaje'] ?? ''}"),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildOrientacionesSection() {
    final orientaciones = CarrerasData.getOrientacionesPorCarrera(carreraSeleccionada!['carrera']);
    if (orientaciones.isEmpty) return SizedBox();

    return ExpansionTile(
      title: Text(
        'Orientaciones',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: showOrientaciones,
      onExpansionChanged: (expanded) => setState(() => showOrientaciones = expanded),
      children: [
        ...orientaciones.map((orientacion) {
          final materias = CarrerasData.getMateriasPorOrientacion(
            carreraSeleccionada!['carrera'],
            orientacion['nombre']
          );
          
          return ExpansionTile(
            title: Text(orientacion['nombre'] ?? 'Orientación'),
            children: [
              ...materias.map((materia) => _buildMateriaCard(materia)).toList(),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildElectivosSection() {
    final electivos = CarrerasData.getEspaciosAprendizajeElectivos(carreraSeleccionada!['carrera']);
    if (electivos == null) return SizedBox();

    return ExpansionTile(
      title: Text(
        'Espacios de Aprendizaje Electivos',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        ...electivos.entries.map((entry) {
          return ExpansionTile(
            title: Text(entry.key),
            children: [
              ...entry.value.map((materia) => _buildMateriaCard(materia)).toList(),
            ],
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carreraSeleccionada == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    String carreraNombre = carreraSeleccionada!['carrera'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Pensum de $carreraNombre'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _salir,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pensum de la carrera de $carreraNombre',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}