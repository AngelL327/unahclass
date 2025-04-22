import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:unahclass/Screens/estadisticas_screen.dart';
import 'package:unahclass/widgets/helper.dart';

class CalculoIndiceScreen extends StatefulWidget {
  const CalculoIndiceScreen({super.key});

  @override
  State<CalculoIndiceScreen> createState() => _CalculoIndiceScreenState();
}

class _CalculoIndiceScreenState extends State<CalculoIndiceScreen> {
  List<Map<String, dynamic>> materiasSeleccionadas = [];
  Map<String, dynamic>? carreraSeleccionada;
  List<TextEditingController> _controllers = [];
  double indice = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
    
  }

  Future<void> _guardarNotas() async {
    
    List<String> notas = _controllers.map((c) => c.text).toList();
    await UserPrefs.setStringList('notasMaterias', notas);
  }

  Future<void> _cargarDatos() async {


    String? carreraString = await UserPrefs.getString('carreraSeleccionada');
    if (carreraString != null) {
      carreraSeleccionada = json.decode(carreraString);
    }

    final materiasAprobadas = await UserPrefs.getStringList('materiasSeleccionadas') ?? [];
    final notasGuardadas = await UserPrefs.getStringList('notasMaterias') ?? [];

    _cargarMaterias(materiasAprobadas, notasGuardadas);
    _actualizarIndice();
  }

  void _cargarMaterias(List<String> materiasAprobadas, List<String> notasGuardadas) {
    List<Map<String, dynamic>> materiasDetalles = [];

    if (carreraSeleccionada != null) {
      final materiasCarrera = carreraSeleccionada!['materias'] as List<dynamic>;

      for (var materia in materiasCarrera) {
        if (materiasAprobadas.contains(materia['codigo'])) {
          materiasDetalles.add(Map<String, dynamic>.from(materia));
        }
      }
    }

    setState(() {
      materiasSeleccionadas = materiasDetalles;
      _controllers = List.generate(
        materiasSeleccionadas.length,
        (index) {
          final controller = TextEditingController();
          if (index < notasGuardadas.length) {
            controller.text = notasGuardadas[index];
          }
          controller.addListener(() {
            _actualizarIndice();
            _guardarNotas(); // Guarda cada vez que cambia una nota
          });
          return controller;
        },
      );
    });
  }

  void _actualizarIndice() {
    double totalUv = 0;
    double totalNotas = 0;

    for (int i = 0; i < materiasSeleccionadas.length; i++) {
      double? nota = double.tryParse(_controllers[i].text);
      if (nota != null && nota >= 0 && nota <= 100) {
        totalNotas += nota * materiasSeleccionadas[i]['uv'];
        totalUv += materiasSeleccionadas[i]['uv'];
      }
    }

    setState(() {
      indice = totalUv > 0 ? totalNotas / totalUv : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calcular Índice', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF1D9FCB),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EstadisticasScreen(
                      materias: materiasSeleccionadas,
                      notas: _controllers.map((c) => c.text).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Tu índice es: ${indice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: materiasSeleccionadas.isEmpty
                    ? const Center(
                        child: Text(
                          "No tienes materias seleccionadas.",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: materiasSeleccionadas.length,
                        itemBuilder: (context, index) {
                          final materia = materiasSeleccionadas[index];
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
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      title: Text(
                                        materia['asignatura'] ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        'Código: ${materia['codigo']} | UV: ${materia['uv']}',
                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 80,
                                      child: TextField(
                                        controller: _controllers[index],
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Nota',
                                          border: OutlineInputBorder(),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Índice Calculado'),
                      content: Text('Tu índice es: ${indice.toStringAsFixed(2)}'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Aceptar'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9FCB),
                ),
                child: const Text('Mostrar Índice', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
