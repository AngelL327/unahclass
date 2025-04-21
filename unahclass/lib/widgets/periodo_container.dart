import 'package:flutter/material.dart';
import 'materia_card.dart';

class PeriodoContainer extends StatelessWidget {
  final String periodo;
  final List<Map<String, dynamic>> materias;

  const PeriodoContainer({
    super.key,
    required this.periodo,
    required this.materias,
  });

  @override
  Widget build(BuildContext context) {
    final periodoDisplay = periodo.isEmpty ? 'Periodo no definido' : 'Periodo $periodo';

    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              periodoDisplay,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          Expanded(
            child: materias.isEmpty
                ? const Center(
                    child: Text(
                      'No hay materias disponibles',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: materias.length,
                    itemBuilder: (context, index) {
                      return MateriaCard(materia: materias[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}