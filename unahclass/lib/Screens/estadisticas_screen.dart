import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:unahclass/widgets/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EstadisticasScreen extends StatefulWidget {
  final List<Map<String, dynamic>> materias;
  final List<String> notas;

  const EstadisticasScreen({
    super.key,
    required this.materias,
    required this.notas,
  });

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  final Set<int> seleccionadas = {};

  late final List<Map<String, dynamic>> ultimasMaterias;
  late final List<String> ultimasNotas;

  @override
  void initState() {
    super.initState();

    // Obtenemos solo las últimas 9 materias y notas
    final total = widget.materias.length;
    final start = total > 9 ? total - 9 : 0;
    ultimasMaterias = widget.materias.sublist(start);
    ultimasNotas = widget.notas.sublist(start);

    _cargarSeleccionadas();
  }

  Future<void> _cargarSeleccionadas() async {
    final seleccionGuardada = await  UserPrefs.getStringList('seleccionadas_estadisticas') ?? [];
    setState(() {
      seleccionadas.addAll(seleccionGuardada.map(int.parse).where((i) => i < ultimasMaterias.length));
    });
  }

  Future<void> _guardarSeleccionadas() async {
    await  UserPrefs.setStringList(
      'seleccionadas_estadisticas',
      seleccionadas.map((e) => e.toString()).toList(),
    );
  }

  Future<void> _limpiarSeleccionadas() async {
    await  UserPrefs.remove('seleccionadas_estadisticas');
    setState(() {
      seleccionadas.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D9FCB),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _limpiarSeleccionadas,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: ultimasMaterias.length,
              itemBuilder: (context, index) {
                final materia = ultimasMaterias[index];
                final nota = double.tryParse(ultimasNotas[index]) ?? 0.0;

                return CheckboxListTile(
                  value: seleccionadas.contains(index),
                  onChanged: (selected) {
                    setState(() {
                      if (selected == true) {
                        seleccionadas.add(index);
                      } else {
                        seleccionadas.remove(index);
                      }
                    });
                    _guardarSeleccionadas();
                  },
                  title: Text(materia['asignatura'] ?? ''),
                  subtitle: Text('Nota: ${nota.toStringAsFixed(1)} | UV: ${materia['uv']}'),
                );
              },
            ),
          ),
          if (seleccionadas.isNotEmpty)
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int idx = value.toInt();
                            if (idx >= seleccionadas.length) return const SizedBox();
                            return Text(
                              ultimasMaterias[seleccionadas.elementAt(idx)]['asignatura']
                                  .toString()
                                  .split(" ")
                                  .first,
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    barGroups: List.generate(seleccionadas.length, (i) {
                      final idx = seleccionadas.elementAt(i);
                      final nota = double.tryParse(ultimasNotas[idx]) ?? 0.0;

                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: nota,
                            color: Colors.blueAccent,
                            width: 18,
                            borderRadius: BorderRadius.circular(4),
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ElevatedButton(
            onPressed: () {
              double totalUv = 0;
              double totalNotas = 0;

              for (int index in seleccionadas) {
                final nota = double.tryParse(ultimasNotas[index]) ?? 0.0;
                final uv = ultimasMaterias[index]['uv'];
                totalNotas += nota * uv;
                totalUv += uv;
              }

              final indiceParcial = totalUv > 0 ? totalNotas / totalUv : 0.0;

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Índice de seleccionadas'),
                  content: Text('Tu índice parcial es: ${indiceParcial.toStringAsFixed(2)}'),
                  actions: [
                    TextButton(
                      child: const Text('Cerrar'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D9FCB)),
            child: const Text("Calcular índice de seleccionadas", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}