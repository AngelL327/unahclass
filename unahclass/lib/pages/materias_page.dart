import 'package:flutter/material.dart';
import 'package:unahclass/Screens/carreras_screen.dart';
import 'package:unahclass/data/carreras_data.dart';
import 'package:diacritic/diacritic.dart';

class FacultadesPage extends StatefulWidget {
  const FacultadesPage({Key? key}) : super(key: key);

  @override
  _FacultadesPageState createState() => _FacultadesPageState();
}

class _FacultadesPageState extends State<FacultadesPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> sugerencias = [];

  String normalizar(String texto) {
    return removeDiacritics(texto.toLowerCase().trim());
  }

  void _filtrarCarreras(String query) {
    final texto = normalizar(query);
    final todas = CarrerasData.getNombresCarreras();

    setState(() {
      sugerencias =
          todas.where((nombre) => normalizar(nombre).contains(texto)).toList();
    });
  }

  void _irADetalle(String nombreCarrera) {
    final carrera = CarrerasData.getCarreraPorNombre(nombreCarrera);
    if (carrera != null && carrera.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => CarreraDetailScreen(carreraNombre: carrera['carrera']),
        ),
      );
      _searchController.clear();
      setState(() => sugerencias.clear());
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  final List<String> facultadImages = [
    "assets/facultades/Ingenieria.png",
    "assets/facultades/Economicas.png",
    "assets/facultades/Ciencias.png",
    "assets/facultades/Sociales.png",
    "assets/facultades/Humanidades.png",
    "assets/facultades/Juridicas.png",
    "assets/facultades/Quimica.png",
    "assets/facultades/Medicas.png",
  ];

  final List<String> facultades = [
    "FACULTAD DE INGENIERIA",
    "FACULTAD DE CIENCIAS ECONOMICAS",
    "FACULTAD DE CIENCIAS",
    "FACULTAD DE CIENCIAS SOCIALES",
    "FACULTAD DE HUMANIDADES Y ARTES",
    "FACULTAD DE CIENCIAS JURIDICAS",
    "FACULTAD DE QUIMICA Y FARMACIA",
    "FACULTAD DE CIENCIAS MEDICAS",
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
        setState(() {});
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(50),
            ),
            child: AppBar(
              backgroundColor: const Color(0xFF1D9FCB),
              elevation: 4,
              title: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Icon(Icons.search, color: Colors.black),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _searchController,
                        onChanged: _filtrarCarreras,
                        onTap: () {
                          setState(() {});
                        },
                        onSubmitted: _irADetalle,
                        decoration: const InputDecoration(
                          hintText: 'Buscar...',
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _filtrarCarreras('');
                          setState(() {});
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.0),
                          child: Icon(Icons.clear, color: Colors.black),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: facultades.length,
                itemBuilder: (context, index) {
                  return _buildGridTile(context, index);
                },
              ),
            ),

            if (_searchController.text.isNotEmpty && _focusNode.hasFocus)
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child:
                        sugerencias.isEmpty
                            ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("No se encontraron coincidencias"),
                            )
                            : ListView.builder(
                              shrinkWrap: true,
                              itemCount: sugerencias.length,
                              itemBuilder: (context, index) {
                                final sugerencia = sugerencias[index];
                                return ListTile(
                                  title: Text(sugerencia),
                                  onTap: () => _irADetalle(sugerencia),
                                );
                              },
                            ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarrerasScreen(facultad: facultades[index]),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color(0xFF1D9FCB),
        shadowColor: Colors.black54,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      facultadImages[index],
                      fit: BoxFit.contain,
                      width: 70,
                      height: 70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                facultades[index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFAFAFA),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
