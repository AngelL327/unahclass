import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:unahclass/Screens/mi_pensum.dart';
import 'package:unahclass/Screens/seleccionar_carrera.dart';
import 'package:unahclass/pages/Usuario_page.dart';
import 'package:unahclass/pages/calendar_page.dart';
import 'package:unahclass/pages/clases_aprobadas_page.dart';
import 'package:unahclass/pages/clases_pendientes_page.dart';
import 'package:unahclass/pages/clases_sugeridas_page.dart';
import 'package:unahclass/pages/optativas_page.dart';
import 'package:unahclass/pages/settings_page.dart';
import 'package:unahclass/pages/auth_page.dart';
import 'package:unahclass/pages/mis_cursos_pages.dart';
import 'package:unahclass/Screens/carreras_screen.dart';
import 'package:unahclass/pages/materias_page.dart';
import 'package:unahclass/pages/calculo_indice.dart';
import 'package:unahclass/pages/Usuario_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _advancedDrawerController = AdvancedDrawerController();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(
      child: Text(
        "¡Bienvenido a UNAHClass! Tu asistente académico para gestionar tus clases de la UNAH",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    ),
    FacultadesPage(), // Aquí se agrega la pantalla de selección de carreras

    MisCursosPage(),
    CalendarPage(),
    const SettingsPage(),
    PerfilPage(),
    // Pantalla de cierre de sesión
    SeleccionCarreraScreen(),
    OptativasScreen(), // Pantalla de selección de carrera
  ];

  final List<String> _titles = [
    "UNAHClass",
    "Carreras",
    "Mis cursos",
    "Calendar",
    "Configuración",
    "Usuario",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _advancedDrawerController.hideDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("No hay usuario autenticado"));
    }

    final String email = user.email ?? 'Correo no disponible';
    final String? displayName = user.displayName;
    final String uid = user.uid;
    return SafeArea(
      child: AdvancedDrawer(
        //    backdropColor: const Color.fromARGB(255, 27, 160, 201),
        backdropColor: const Color(0xFF1D9FCB),

        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF1D9FCB),
            title: Text(_titles[_selectedIndex]),
            leading: IconButton(
              onPressed: () => _advancedDrawerController.showDrawer(),
              icon: const Icon(Icons.menu),
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/decoration/di1.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              _pages[_selectedIndex],
            ],
          ),
        ),
        drawer: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/decoration/di1.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Container(color: const Color(0xFF1D9FCB).withOpacity(0.66)),
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/decoration/unahclass.jpeg',
                        fit: BoxFit.cover,
                        width: 100, // 2 * radius
                        height: 100,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    displayName ?? 'Estudiante',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white, thickness: 1),
                  const SizedBox(height: 10),

                  _buildDrawerItem(Icons.home, "Home", 0),
                  _buildDrawerItem(Icons.school, "Carreras", 1),
                  ExpansionTile(
                    leading: const Icon(Icons.business, color: Colors.white),
                    title: const Text(
                      "Mi Carrera",
                      style: TextStyle(color: Colors.white),
                    ),
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    childrenPadding: const EdgeInsets.only(left: 20),
                    children: [
                      _buildSubMenu("Seleccionar Carrera"),
                      _buildSubMenu("Mi Pensum"),
                      _buildSubMenu("Clases Aprobadas"),
                      _buildSubMenu("Clases Sugeridas"),
                      _buildSubMenu("Clases Pendientes"),
                      _buildSubMenu("Optativas"),
                      _buildSubMenu("Calcular Indice"),
                    ],
                  ),
                  _buildDrawerItem(Icons.book_sharp, "Mis cursos", 2),
                  _buildDrawerItem(Icons.calendar_today, "Calendar", 3),
                  _buildDrawerItem(Icons.settings, "Settings", 4),
                  _buildDrawerItem(Icons.lock, "Usuario", 5),

                  const SizedBox(height: 20),
                  const Divider(color: Colors.white, thickness: 1),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "© 2025 UNAHClass",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white54,
        size: 18,
      ),
      onTap: () => _onItemTapped(index),
    );
  }

  Widget _buildSubMenu(String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      leading: const Icon(Icons.arrow_right, color: Colors.white54),
      onTap: () {
        if (title == "Mi Pensum") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetalleCarreraScreen()),
          );
        } else if (title == "Seleccionar Carrera") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SeleccionCarreraScreen()),
          );
        } else if (title == "Optativas") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OptativasScreen()),
          );
        } else if (title == "Clases Aprobadas") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClasesAprobadasScreen()),
          );
        } else if (title == "Clases Sugeridas") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClasesSugeridasPage()),
          );
        } else if (title == "Clases Pendientes") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClasesPendientesPage()),
          );
        } else if (title == "Calcular Indice") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalculoIndiceScreen()),
          );
        }

        _advancedDrawerController.hideDrawer();
      },
    );
  }
}
