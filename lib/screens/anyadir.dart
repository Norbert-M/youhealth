import 'package:flutter/material.dart';
import 'package:youhealth/screens/anyadir/anyadir_medicamento.dart';
import 'package:youhealth/screens/anyadir/anyadir_tratamiento.dart';

class AnadirPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Añadir Cita'),
            onTap: () {
              // Aquí puedes manejar el evento de clic en 'Añadir Cita'
              // Por ejemplo, puedes navegar a la pantalla de añadir cita
              // Navigator.push(context, MaterialPageRoute(builder: (context) => AnadirCitaPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.healing),
            title: Text('Añadir Tratamiento'),
            onTap: () {
              // Aquí puedes manejar el evento de clic en 'Añadir Tratamiento'
              // Por ejemplo, puedes navegar a la pantalla de añadir tratamiento
              // Navigator.push(context, MaterialPageRoute(builder: (context) => AnadirTratamientoPage()));

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnadirTratamientoPage()),
          );
            },
          ),
          ListTile(
            leading: Icon(Icons.medical_services),
            title: Text('Añadir Medicamento'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnadirMedicamentoPage()),
          );
            },
          ),
        ],
      ),
    );
  }
}