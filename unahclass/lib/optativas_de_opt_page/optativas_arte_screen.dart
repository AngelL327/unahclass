import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OptativasArteScreen extends StatelessWidget {
  final List<Map<String, dynamic>> clasesArte = [
    {"nombre": "Iniciación a la Danza", "icono": Icon(Icons.group, color: Color(0XFF101c5c))},
    {"nombre": "Danza Folklórica", "icono": FaIcon(FontAwesomeIcons.theaterMasks, color: Color(0XFF101c5c))}, 
    {"nombre": "Teatro en Honduras", "icono": FaIcon(FontAwesomeIcons.masksTheater, color: Color(0XFF101c5c))}, 
    {"nombre": "Fotografía", "icono": FaIcon(FontAwesomeIcons.cameraRetro, color: Color(0XFF101c5c))},
    {"nombre": "Redacción", "icono": FaIcon(FontAwesomeIcons.pen, color: Color(0XFF101c5c))}, 
    {"nombre": "Dibujo y Pintura", "icono": FaIcon(FontAwesomeIcons.paintBrush, color: Color(0XFF101c5c))}, 
    {"nombre": "Apreciación Musical", "icono": FaIcon(FontAwesomeIcons.music, color: Color(0XFF101c5c))},
    {"nombre": "Guitarra Popular", "icono": FaIcon(FontAwesomeIcons.guitar, color: Color(0XFF101c5c))}, 
    {"nombre": "Flauta Dulce", "icono": FaIcon(FontAwesomeIcons.wind, color: Color(0XFF101c5c))}, 
    {"nombre": "Coro Universitario", "icono": Icon(Icons.chat, color: Color(0XFF101c5c))}, 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFffffff),
      appBar: AppBar(
        title: Text(
          "Arte", style: TextStyle(color: Colors.white),
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
                      "Estas son las clases del área de Arte disponibles.\n¡Elige la que mejor se adapte a ti!",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Color(0xFFF0F0F0),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
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
      body:ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: clasesArte.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: Color(0XFFF3F5F9),
              child: ListTile(
                title: Text(
                  clasesArte[index]["nombre"],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                trailing: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: clasesArte[index]["icono"],
                ),
              ),
            );
          },
        ),
    );
  }
}
