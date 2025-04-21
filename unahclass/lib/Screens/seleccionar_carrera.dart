import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unahclass/data/carreras_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:unahclass/Screens/mi_pensum.dart';
import 'package:unahclass/pages/materias_page.dart';
import 'package:unahclass/widgets/search_app_bar.dart';
import 'package:diacritic/diacritic.dart';
import 'package:unahclass/widgets/helper.dart';

class SeleccionCarreraScreen extends StatefulWidget {
  const SeleccionCarreraScreen({super.key});

  @override
  _SeleccionCarreraScreenState createState() => _SeleccionCarreraScreenState();
}

class _SeleccionCarreraScreenState extends State<SeleccionCarreraScreen> {
  List<String> carrerasFiltradas = [];

  Map<String, IconData> carreraIconMap =
      {};

  @override
  void initState() {
    super.initState();
    carrerasFiltradas = CarrerasData.getNombresCarreras();
    carrerasFiltradas = List.from(carrerasFiltradas); 
    _generarIconos();
  }

  
  void _generarIconos() {
    for (String carrera in carrerasFiltradas) {
      carreraIconMap[carrera] = _getIconForCarrera(carrera);
    }
  }


  void _filtrarCarreras(String query) {
    final normalizado = removeDiacritics(query.toLowerCase());

    setState(() {
      carrerasFiltradas =
          carrerasFiltradas.where((carrera) {
            final nombreNormalizado = removeDiacritics(carrera.toLowerCase());
            return nombreNormalizado.contains(normalizado);
          }).toList();
    });
  }

  
  IconData _getIconForCarrera(String nombreCarrera) {
    final nombre = nombreCarrera.toLowerCase();

   
    if (nombre.contains('derecho')) return FontAwesomeIcons.scaleBalanced;
    if (nombre.contains('contaduría pública y finanzas') ||
        nombre.contains('finanzas'))
      return FontAwesomeIcons.calculator;
    if (nombre.contains('administración y generación de empresas'))
      return FontAwesomeIcons.building;
    if (nombre.contains('economía') || nombre.contains('economia'))
      return FontAwesomeIcons.coins;
    if (nombre.contains('informática administrativa') ||
        nombre.contains('informatica administrativa'))
      return FontAwesomeIcons.laptopCode;
    if (nombre.contains('ingeniería civil'))
      return FontAwesomeIcons.hardHat; 
    if (nombre.contains('ingeniería eléctrica industrial') ||
        nombre.contains('electrica industrial'))
      return FontAwesomeIcons.boltLightning; 
    if (nombre.contains('ingeniería en sistemas') ||
        nombre.contains('sistemas'))
      return FontAwesomeIcons.laptop; 
    if (nombre.contains('ingeniería industrial') ||
        nombre.contains('ingenieria'))
      return FontAwesomeIcons.userGear; 
    if (nombre.contains('ingeniería mecánica industrial') ||
        nombre.contains('mecanica industrial'))
      return FontAwesomeIcons.gears; 

    
    if (nombre.contains('letras') &&
        nombre.contains('orientación en lingüística'))
      return FontAwesomeIcons.bookOpen; 
    if (nombre.contains('letras') &&
        nombre.contains('orientación en literatura'))
      return FontAwesomeIcons.bookOpen; 

    
    if (nombre.contains('matemática con orientación en ingeniería matemática'))
      return FontAwesomeIcons.calculator; 
    if (nombre.contains('matemática con orientación en estadística'))
      return FontAwesomeIcons.chartLine; 
    if (nombre.contains('matemática orientación informática'))
      return FontAwesomeIcons.laptopCode; 
    if (nombre.contains('matemática orientación sistemas de operaciones'))
      return FontAwesomeIcons.cogs; 

    
    if (nombre.contains('pedagogía y ciencias de la educación') &&
        nombre.contains(
          'orientación administración y planeamiento de la educación',
        ))
      return FontAwesomeIcons.chalkboardTeacher; 
    if (nombre.contains('pedagogía y ciencias de la educación') &&
        nombre.contains('orientación educativa'))
      return FontAwesomeIcons.chalkboard; 
    if (nombre.contains('pedagogía y ciencias de la educación') &&
        nombre.contains('orientación en educación de adultos'))
      return FontAwesomeIcons.chalkboardTeacher; 
    if (nombre.contains('pedagogía y ciencias de la educación') &&
        nombre.contains('orientación en educación especial'))
      return FontAwesomeIcons.chalkboardTeacher; 

    // Otras carreras
    if (nombre.contains('periodismo'))
      return FontAwesomeIcons.newspaper;
    if (nombre.contains('psicología') || nombre.contains('psicologia'))
      return FontAwesomeIcons.brain; 
    if (nombre.contains('sociología') || nombre.contains('sociologia'))
      return FontAwesomeIcons.peopleGroup; 
    if (nombre.contains('técnico universitario en máquinas herramientas cnc'))
      return FontAwesomeIcons.tools; 
    if (nombre.contains('licenciatura en química industrial') ||
        nombre.contains('quimica'))
      return FontAwesomeIcons.flask; 
    if (nombre.contains(
      'técnico universitario en seguridad e higiene industrial',
    ))
      return FontAwesomeIcons.shieldAlt; 
    if (nombre.contains('enfermería') || nombre.contains('enfermeria'))
      return FontAwesomeIcons.userNurse; 
    if (nombre.contains('medicina y cirugía') || nombre.contains('cirugia'))
      return FontAwesomeIcons.userDoctor; 
    if (nombre.contains('odontología') || nombre.contains('odontologia'))
      return FontAwesomeIcons.tooth; 


    
    return FontAwesomeIcons.graduationCap;
  }

 
  Future<void> _guardarCarreraSeleccionada(String nombreCarrera) async {
    final carrera = CarrerasData.getCarreraPorNombre(nombreCarrera);
    if (carrera == null) return;


    await UserPrefs.setString('carreraSeleccionada', json.encode(carrera));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DetalleCarreraScreen()),
    );
  }
  