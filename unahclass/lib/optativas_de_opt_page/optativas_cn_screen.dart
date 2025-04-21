import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OptativasCNScreen extends StatelessWidget {
  final List<Map<String, dynamic>> clasesDeCN = [
    {"nombre": "Ciencias de la Tierra", "icono": Icon(Icons.public, color: Color(0XFF101c5c))},
    {"nombre": "Educación Ambiental", "icono": Icon(Icons.eco, color: Color(0XFF101c5c))},
    {"nombre": "Introducción a las Aeronaves", "icono": Icon(Icons.airplanemode_active, color: Color(0XFF101c5c))},
    {"nombre": "Introducción a la Astronomía", "icono": FaIcon(FontAwesomeIcons.meteor, color: Color(0XFF101c5c))},
    {"nombre": "Energía y Cambio Climático", "icono": FaIcon(FontAwesomeIcons.bolt, color: Color(0XFF101c5c))},
    {"nombre": "Introducción a la Arqueoastronomía", "icono": Icon(Icons.auto_stories ,color: Color(0XFF101c5c))},
    {"nombre": "Introducción a la Arqueoastronomía Maya", "icono": Icon(Icons.history_edu, color: Color(0XFF101c5c))},
    {"nombre": "Introducción al Sistema Solar", "icono": FaIcon(FontAwesomeIcons.satellite, color: Color(0XFF101c5c))},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFffffff),
      appBar: AppBar(
        title: Text(
          "Ciencias Naturales",
          style: TextStyle(color: Colors.white),
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
                      "Estas son las clases del área de Ciencias Naturales disponibles.\n¡Elige la que mejor se adapte a ti!",
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
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: clasesDeCN.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            color: Color(0XFFF3F5F9),
            child: ListTile(
              title: Text(
                clasesDeCN[index]["nombre"],
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              trailing: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: clasesDeCN[index]["icono"],
              ),
            ),
          );
        },
      ),
    );
  }
}