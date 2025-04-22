import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:unahclass/widgets/helper.dart';

class ClasesSugeridasPage extends StatefulWidget {
  const ClasesSugeridasPage({super.key});

  @override
  State<ClasesSugeridasPage> createState() => _ClasesSugeridasPageState();
}

class _ClasesSugeridasPageState extends State<ClasesSugeridasPage> {
  List<Map<String, dynamic>> sugeridas = [];
  List<String> materiasAprobadas = [];
  Map<String, dynamic>? carreraSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    materiasAprobadas =
        await UserPrefs.getStringList('materiasSeleccionadas') ?? [];

    String? carreraString = await UserPrefs.getString('carreraSeleccionada');
    if (carreraString != null) {
      carreraSeleccionada = json.decode(carreraString);
    }

    if (carreraSeleccionada != null) {
      _generarSugeridas();
    }
  }

  void _generarSugeridas() {
    final todasMaterias = carreraSeleccionada!['materias'] as List<dynamic>;

    final pendientes =
        todasMaterias.where((materia) {
          final codigo = materia['codigo']?.toString();
          return codigo != null && !materiasAprobadas.contains(codigo);
        }).toList();

    final List<Map<String, dynamic>> sugerencias = [];

    for (var materia in pendientes) {
      final requisitoRaw = materia['requisito']?.toString().trim();

      if (requisitoRaw == null ||
          requisitoRaw.isEmpty ||
          requisitoRaw.toLowerCase() == 'ninguno' ||
          requisitoRaw.toLowerCase() == 'ninguna') {
        sugerencias.add(Map<String, dynamic>.from(materia));
        continue;
      }

      final requisitos =
          requisitoRaw
              .replaceAll(RegExp(r'[,/]'), ' ')
              .split(' ')
              .where((r) => r.isNotEmpty)
              .toList();

      final todosCumplidos = requisitos.every(
        (codigo) => materiasAprobadas.contains(codigo),
      );

      if (todosCumplidos) {
        sugerencias.add(Map<String, dynamic>.from(materia));
      }
    }

    setState(() {
      sugeridas = sugerencias;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clases Sugeridas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1D9FCB),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            sugeridas.isEmpty
                ? const Center(
                  child: Text(
                    "No hay clases sugeridas.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                : ListView.builder(
                  itemCount: sugeridas.length,
                  itemBuilder: (context, index) {
                    final materia = sugeridas[index];
                    final nombre =
                        materia['asignatura']?.toString() ??
                        'Nombre no disponible';
                    final codigo =
                        materia['codigo']?.toString() ?? 'Sin código';
                    final requisito =
                        materia['requisito']?.toString() ?? 'Ninguno';

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
                                color:
                                    Colors.primaries[index %
                                        Colors.primaries.length],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                title: Text(
                                  nombre,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Código: $codigo | Requisito: $requisito',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
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
    );
  }
}
