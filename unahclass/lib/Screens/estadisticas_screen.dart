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

