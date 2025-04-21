import 'package:flutter/material.dart';

class MateriaCard extends StatelessWidget {
  final Map<String, dynamic> materia;

  const MateriaCard({super.key, required this.materia});

  @override
  Widget build(BuildContext context) {
    final codigo = materia['codigo']?.toString() ?? 'Sin código';
    final asignatura = materia['asignatura']?.toString() ?? 'Sin nombre';
    final uv = materia['uv']?.toString() ?? 'N/A';
    final requisito = materia['requisito']?.toString() ?? 'Ninguno';

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[100]!,
            blurRadius: 2,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              codigo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              asignatura,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              'UV: $uv',
              style: TextStyle(
                fontSize: 11,
                color: Colors.blue[600],
              ),
            ),
            if (requisito != "Ninguno")
              Text(
                'Req: $requisito',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue[400],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}