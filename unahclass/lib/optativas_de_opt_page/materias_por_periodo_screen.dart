import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unahclass/widgets/helper.dart';

class MateriasPorPeriodoScreen extends StatefulWidget {
  final List<Map<String, dynamic>> materias;
  final String nombrePeriodo;

  const MateriasPorPeriodoScreen({
    required this.materias,
    required this.nombrePeriodo,
  });

  @override
  State<MateriasPorPeriodoScreen> createState() =>
      _MateriasPorPeriodoScreenState();
}

class _MateriasPorPeriodoScreenState extends State<MateriasPorPeriodoScreen> {
  Set<String> materiasSeleccionadas = {};

  @override
  void initState() {
    super.initState();
    _cargarMateriasSeleccionadas();
  }

  Future<void> _cargarMateriasSeleccionadas() async {
    List<String>? seleccionadas = await UserPrefs.getStringList(
      'materiasSeleccionadas',
    );
    setState(() {
      materiasSeleccionadas = seleccionadas?.toSet() ?? {};
    });
  }

  Future<void> _toggleSeleccion(String codigo) async {
    setState(() {
      if (materiasSeleccionadas.contains(codigo)) {
        materiasSeleccionadas.remove(codigo);
      } else {
        materiasSeleccionadas.add(codigo);
      }
    });
    await UserPrefs.setStringList(
      'materiasSeleccionadas',
      materiasSeleccionadas.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nombrePeriodo,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1d9fcb),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 25),
        itemCount: widget.materias.length,
        itemBuilder: (context, index) {
          final materia = widget.materias[index];
          final nombre = materia['asignatura'] ?? 'Sin nombre';
          final codigo = materia['codigo'] ?? 'Sin código';

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: CheckboxListTile(
              value: materiasSeleccionadas.contains(codigo),
              onChanged: (_) => _toggleSeleccion(codigo),
              title: Text(
                nombre,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color:
                      materiasSeleccionadas.contains(codigo)
                          ? Color(0xFF1d9fcb)
                          : Colors.black,
                ),
              ),
              subtitle: Text(
                'Código: $codigo',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              activeColor: Color(0xFF1d9fcb),
              checkColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
          );
        },
      ),
    );
  }
}
