import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unahclass/widgets/helper.dart';

class DetalleCursoPage extends StatefulWidget {
  final Map<String, dynamic> curso;

  const DetalleCursoPage({super.key, required this.curso});

  @override
  State<DetalleCursoPage> createState() => _DetalleCursoPageState();
}

class _DetalleCursoPageState extends State<DetalleCursoPage> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _apunteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    _tituloController.text = await UserPrefs.getString('titulo') ?? 'Título'; 
      _apunteController.text = await UserPrefs.getString('apunte') ?? 'Cualquier apunte que realices acerca de la clase'; 
    setState(() {
      _tituloController.text;
      _apunteController.text;
    });
  } 

    Future<void> _guardarDatos() async {
    
    await UserPrefs.setString('titulo', _tituloController.text);
    await UserPrefs.setString('apunte', _apunteController.text);
  }
  
  Future<void> _subirArchivo() async {
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (resultado != null) {
      final archivo = File(resultado.files.single.path!);
      final nombreArchivo = resultado.files.single.name;
      final cursoId = widget.curso['codigo'];
      final extension = nombreArchivo.split('.').last.toLowerCase();
      final tipo = (extension == 'pdf') ? 'pdf' : 'imagen';

      final ref = FirebaseStorage.instance.ref().child(
        'documentos/$cursoId/$nombreArchivo',
      );

      await ref.putFile(archivo);
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('cursos')
          .doc(cursoId)
          .collection('documentos')
          .add({'nombre': nombreArchivo, 'url': url, 'tipo': tipo});
    }
  }

  void _mostrarDocumento(BuildContext context, String url, String? tipo) {
    final docType = tipo ?? 'imagen';

    if (docType == 'imagen') {
      showDialog(
        context: context,
        builder:
            (_) => Dialog(
              backgroundColor: Colors.transparent,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: InteractiveViewer(child: Image.network(url)),
              ),
            ),
      );
    } else {
      OpenFile.open(url);
    }
  }

  Widget _buildDocumentoWidget(String url, String? tipo) {
    final docType = tipo ?? 'imagen';

    if (docType == 'imagen') {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) =>
                const Center(child: Icon(Icons.image)),
      );
    } else {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.picture_as_pdf, size: 48, color: Colors.red),
              SizedBox(height: 8),
              Text('PDF', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cursoId = widget.curso['codigo'];
    final documentosRef = FirebaseFirestore.instance
        .collection('cursos')
        .doc(cursoId)
        .collection('documentos');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0XFF1D9FCB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.curso['nombre'],
          style: const TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _apunteController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Cualquier apunte que realices acerca de la clase',
                      ),
                      onChanged: (text) {
                        _guardarDatos(); 
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: StreamBuilder<QuerySnapshot>(
                  stream: documentosRef.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final url = data['url'];
                        final tipo = data['tipo'];

                        return GestureDetector(
                          onTap: () => _mostrarDocumento(context, url, tipo),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildDocumentoWidget(url, tipo),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0XFF1D9FCB),
        child: const Icon(Icons.upload_file),
        onPressed: _subirArchivo,
      ),
    );
  }
}
