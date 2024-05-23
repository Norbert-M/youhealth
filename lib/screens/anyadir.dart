import 'package:flutter/material.dart';
import 'package:youhealth/Entity/cita_medico.dart';
import 'package:youhealth/assets/colors.dart';
import 'package:youhealth/screens/anyadir/anyadir_cita.dart';
import 'package:youhealth/screens/anyadir/anyadir_hospital.dart';
import 'package:youhealth/screens/anyadir/anyadir_medicamento.dart';
import 'package:youhealth/screens/anyadir/anyadir_tratamiento.dart';

class AnadirPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.barColor,
        title: const Text('Añadir',
          style: TextStyle(color: Colors.white),
        )
      ),
      body: Container(
        color: Color.fromARGB(255, 217, 217, 217),
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Añadir Cita'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnadirCitaPage()),
                  );
                },
              ),
            ),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                leading: const Icon(Icons.healing),
                title: const Text('Añadir Tratamiento'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnadirTratamientoPage()),
                  );
                },
              ),
            ),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                leading: const Icon(Icons.medical_services),
                title: const Text('Añadir Medicamento'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnadirMedicamentoPage()),
                  );
                },
              ),
            ),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                leading: const Icon(Icons.local_hospital),
                title: const Text('Añadir Hospital'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnadirHospitalPage()),
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