import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OptativasDeportesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> clasesDeDeporte = [
    {"nombre": "Ajedrez", "icono": FaIcon(FontAwesomeIcons.chess, color: Color(0XFF101c5c))},
    {"nombre": "Defensa Personal", "icono": Icon(Icons.security, color: Color(0XFF101c5c))},
    {"nombre": "Fútbol", "icono": FaIcon(FontAwesomeIcons.futbol, color: Color(0XFF101c5c))},
    {"nombre": "Fútbol Sala", "icono": FaIcon(FontAwesomeIcons.futbol, color: Color(0XFF101c5c))},
    {"nombre": "Gimnasia General", "icono": Icon(Icons.directions_run, color: Color(0XFF101c5c))},
    {"nombre": "Juegos Organizados", "icono": Icon(Icons.sports_kabaddi, color: Color(0XFF101c5c))},
    {"nombre": "Primeros Auxilios", "icono": Icon(Icons.health_and_safety, color: Color(0XFF101c5c))},
    {"nombre": "Voleibol", "icono": Icon(Icons.sports_volleyball, color: Color(0XFF101c5c))},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFffffff),
      appBar: AppBar(
        title: Text(
          "Deportes",
          style: TextStyle(color: Colors.white,),
        ),
        backgroundColor: Color(0XFF1D9FCB),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.help_rounded, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                      "Estas son las clases del área de Deportes disponibles.\n¡Elige la que mejor se adapte a ti!",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.grey[100],
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "CERRAR",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),