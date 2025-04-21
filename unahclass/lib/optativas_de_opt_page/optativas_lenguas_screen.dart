import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OptativasLenguasScreen extends StatelessWidget {
  final List<Map<String, dynamic>> clasesLenguas = [
    {"nombre": "Alemán", "icono": FaIcon(FontAwesomeIcons.flag, color: Color(0XFF101c5c))},
    {"nombre": "Francés", "icono": FaIcon(FontAwesomeIcons.flag, color: Color(0XFF101c5c))},
    {"nombre": "Inglés", "icono": FaIcon(FontAwesomeIcons.flagUsa, color: Color(0XFF101c5c))},
    {"nombre": "Italiano", "icono": FaIcon(FontAwesomeIcons.flag, color: Color(0XFF101c5c))},
    {"nombre": "Portugués", "icono": FaIcon(FontAwesomeIcons.flag, color: Color(0XFF101c5c))},
    {"nombre": "Ruso", "icono": FaIcon(FontAwesomeIcons.flag, color: Color(0XFF101c5c))},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFffffff),
      appBar: AppBar(
        title: Text("Lenguas Extranjeras", style: TextStyle(color: Colors.white),),
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
                      "Estas son las clases de Lenguas Extranjeras disponibles.\n¡Elige la que mejor se adapte a ti!",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.grey[100],
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                        },
                        child: Text("CERRAR", style: TextStyle(color: Colors.grey),),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),