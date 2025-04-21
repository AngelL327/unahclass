import 'package:flutter/material.dart';
import 'package:unahclass/optativas_de_opt_page/optativas_arte_screen.dart';
import 'package:unahclass/optativas_de_opt_page/optativas_cn_screen.dart';
import 'package:unahclass/optativas_de_opt_page/optativas_deportes_screen.dart';
import 'package:unahclass/optativas_de_opt_page/optativas_humanidades_screen.dart';
import 'package:unahclass/optativas_de_opt_page/optativas_lenguas_screen.dart';

class OptativasScreen extends StatefulWidget {
  @override
  _OptativasScreenState createState() => _OptativasScreenState();
}

class _OptativasScreenState extends State<OptativasScreen> {
  final List<Map<String, String>> optativas = [
    {"title": "OPTATIVAS DEL ÁREA DE ARTE", "image": "assets/logos/2.png"},
    {
      "title": "OPTATIVAS DEL ÁREA DE CIENCIAS NATURALES",
      "image": "assets/logos/4.png",
    },
    {
      "title": "OPTATIVAS DEL ÁREA DE LOS DEPORTES",
      "image": "assets/logos/3.png",
    },
    {
      "title": "OPTATIVAS DEL ÁREA DE HUMANIDADES",
      "image": "assets/logos/2.png",
    },
    {
      "title": "OPTATIVAS DE LENGUAS EXTRANJERAS",
      "image": "assets/logos/1.png",
    },
  ];

  List<Map<String, String>> filteredOptativas = [];

  @override
  void initState() {
    super.initState();
    filteredOptativas = optativas;
  }

  void _filterOptativas(String query) {
    setState(() {
      filteredOptativas =
          optativas
              .where(
                (optativa) => optativa["title"]!.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        title: Text("Clases Optativas", style: TextStyle(color: Colors.white)),
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
                      "¿No sabes qué optativa elegir?\nEn este apartado te mostramos cuales son las que puedes elegir, explora cada área y encuentra la que mejor se adapte a ti.",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.grey[100],
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          "CERRAR",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: _filterOptativas,
              decoration: InputDecoration(
                hintText: "Buscar...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  int crossAxisCount =
                      orientation == Orientation.portrait ? 2 : 2;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1,
                    ),
                    itemCount: filteredOptativas.length,
                    itemBuilder: (context, index) {
                      return OptativaCard(
                        title: filteredOptativas[index]["title"]!,
                        imageUrl: filteredOptativas[index]["image"]!,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptativaCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const OptativaCard({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == "OPTATIVAS DEL ÁREA DE LOS DEPORTES") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OptativasDeportesScreen()),
          );
        } else if (title == "OPTATIVAS DEL ÁREA DE HUMANIDADES") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OptativasHumanidadesScreen(),
            ),
          );
        } else if (title == "OPTATIVAS DEL ÁREA DE CIENCIAS NATURALES") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OptativasCNScreen()),
          );
        } else if (title == "OPTATIVAS DEL ÁREA DE ARTE") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OptativasArteScreen()),
          );
        } else if (title == "OPTATIVAS DE LENGUAS EXTRANJERAS") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OptativasLenguasScreen()),
          );
        }
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.only(left: 16, right: 16, top: 70, bottom: 16),
            decoration: BoxDecoration(
              color: Color(0XFF1D9FCB),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 27,
            child: ClipOval(
              child: Container(
                width: 60,
                height: 60,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Image.asset(imageUrl, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
