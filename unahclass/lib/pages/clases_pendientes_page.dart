import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unahclass/widgets/helper.dart';

class ClasesPendientesPage extends StatefulWidget {
  const ClasesPendientesPage({super.key});

  @override
  State<ClasesPendientesPage> createState() => _ClasesPendientesPageState();
}

class _ClasesPendientesPageState extends State<ClasesPendientesPage> {
  List<Map<String, dynamic>> clasesPendientesDetalles = [];

  @override
  void initState() {
    super.initState();
    _cargarClasesPendientes();
  }

  Future<void> _cargarClasesPendientes() async {
    final clasesSeleccionadas =
        await UserPrefs.getStringList('materiasSeleccionadas') ?? [];

    Set<String> materiasAgregadas = {};
    List<Map<String, dynamic>> clasesPendientes = [];

    // carrera seleccionada
    String? carreraString = await UserPrefs.getString('carreraSeleccionada');
    if (carreraString != null) {
      Map<String, dynamic> carrera = json.decode(carreraString);

      //filtra las materias pendientes de la carrera
      for (var materia in carrera['materias']) {
        if (!clasesSeleccionadas.contains(materia['codigo']) &&
            !materiasAgregadas.contains(materia['codigo'])) {
          clasesPendientes.add(materia);
          materiasAgregadas.add(materia['codigo']);
        }
      }
    }

    setState(() {
      clasesPendientesDetalles = clasesPendientes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clases Pendientes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1D9FCB),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            clasesPendientesDetalles.isEmpty
                ? const Center(
                  child: Text(
                    "No hay clases pendientes.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                : ListView.builder(
                  itemCount: clasesPendientesDetalles.length,
                  itemBuilder: (context, index) {
                    final materia = clasesPendientesDetalles[index];
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
                                  materia['asignatura'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Código: ${materia['codigo']} | UV: ${materia['uv']} | Requisito: ${materia['requisito']}',
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
