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

