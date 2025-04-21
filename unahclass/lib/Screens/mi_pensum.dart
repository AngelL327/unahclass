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

  