import 'package:flutter/material.dart';

class OptativasHumanidadesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> clasesHumanidades = [
    {"nombre": "Antropología General", "icono": Icons.public},
    {"nombre": "Ciencias Políticas", "icono": Icons.account_balance},
    {"nombre": "Derechos Humanos en Honduras", "icono": Icons.gavel}, 
    {"nombre": "Estudio de la Mujer", "icono": Icons.wc},
    {"nombre": "Literatura Hondureña y Ortografía", "icono": Icons.library_books}, 
    {"nombre": "Redacción General", "icono": Icons.edit}, 
    {"nombre": "Técnicas de Lecturas", "icono": Icons.menu_book},
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFffffff),
      appBar: AppBar(
        title: Text("Humanidades", style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0XFF1D9FCB),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.help_rounded, color: Colors.white), // Icono de ayuda (?)
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                      "Estas son las clases del área de Humanidades disponibles.\n¡Elige la que mejor se adapte a ti!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: clasesHumanidades.length,
        itemBuilder: (context, index) {
          return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: Color(0XFFF3F5F9),
              child: ListTile(
                title: Text(
                  clasesHumanidades[index]['nombre'],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                trailing: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    clasesHumanidades[index]["icono"], // Puedes cambiarlo a otro ícono relevante
                    color: Color(0XFF101c5c), // Color del ícono
                  ),
                ),
              ),
            );
          },
        ),
      );
  }
}
