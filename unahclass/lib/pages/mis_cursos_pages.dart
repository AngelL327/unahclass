import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unahclass/pages/cursos_detalle.dart';
import 'package:unahclass/widgets/helper.dart';

class MisCursosPage extends StatefulWidget {
  const MisCursosPage({super.key});

  @override
  State<MisCursosPage> createState() => _MisCursosPageState();
}

class _MisCursosPageState extends State<MisCursosPage> {
  List<Map<String, dynamic>> _cursos = [];
  List<dynamic> _materiasDisponibles = [];

  @override
  void initState() {
    super.initState();
    _cargarMateriasDesdePreferencias();
    _cargarCursosDesdePreferencias();
  }

  Future<void> _cargarMateriasDesdePreferencias() async {
    String? carreraJson = await UserPrefs.getString('carreraSeleccionada');
    if (carreraJson != null) {
      final decoded = json.decode(carreraJson);
      setState(() {
        _materiasDisponibles = decoded['materias'];
      });
    }
  }

  Future<void> _guardarCursosEnPreferencias() async {
    String cursosJson = jsonEncode(_cursos);
    await UserPrefs.setString('misCursos', cursosJson);
  }

  Future<void> _cargarCursosDesdePreferencias() async {
    String? cursosJson = await UserPrefs.getString('misCursos');
    if (cursosJson != null) {
      setState(() {
        _cursos = List<Map<String, dynamic>>.from(jsonDecode(cursosJson));
      });
    }
  }

  void _mostrarOpcionesAgregar(BuildContext context) {
    if (_materiasDisponibles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No hay materias disponibles para agregar."),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seleccionar un curso para agregar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: _materiasDisponibles.length,
                  itemBuilder: (context, index) {
                    final curso = _materiasDisponibles[index];
                    final yaAgregado = _cursos.any(
                      (c) => c['codigo'] == curso['codigo'],
                    );

                    return ListTile(
                      enabled: !yaAgregado,
                      leading: const Icon(Icons.book, color: Colors.blue),
                      title: Text(curso['asignatura']),
                      subtitle: Text(curso['codigo']),
                      trailing:
                          yaAgregado
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                      onTap:
                          yaAgregado
                              ? null
                              : () {
                                Navigator.pop(context);
                                setState(() {
                                  _cursos.add({
                                    'nombre': curso['asignatura'],
                                    'codigo': curso['codigo'],
                                    'periodo': '2025-1',
                                  });
                                });
                                _guardarCursosEnPreferencias();
                              },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Mis Cursos",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Añade tus clases del periodo actual",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            color: Colors.grey[200],
            height: 220,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _buildCardAddCurso(),
                ..._cursos.reversed
                    .map((curso) => _buildCardCurso(curso))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardAddCurso() {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () => _mostrarOpcionesAgregar(context),
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFF1BA0C9),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 48, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  "Añadir curso",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardCurso(Map<String, dynamic> curso) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleCursoPage(curso: curso),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, size: 48, color: Color(0xFF1BA0C9)),
                const SizedBox(height: 12),
                Text(
                  curso['nombre'],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  curso['codigo'],
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
