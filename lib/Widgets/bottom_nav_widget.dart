import 'package:flutter/material.dart';
import 'package:youhealth/assets/colors.dart';
import 'package:youhealth/screens/historial.dart';
import 'package:youhealth/screens/principal.dart';
 // Asegúrate de importar el archivo correcto

class BottomNavWidget extends StatefulWidget {
  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    PrincipalPage(),
    HistorialPage(),
    const Text('Configuración'),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.barColor, // Cambiar el color de fondo aquí
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white), // Cambiar el color del ícono aquí
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services, color: Colors.white), // Cambiar el color del ícono aquí
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white), // Cambiar el color del ícono aquí
            label: 'Configuración',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Color.fromARGB(255, 180, 180, 180), // Cambiar el color del ícono no seleccionado aquí
        onTap: _onItemTapped,
      ),
    );
  }
}