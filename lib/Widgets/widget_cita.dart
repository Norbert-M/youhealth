import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youhealth/Entity/cita_medico.dart';
import 'package:youhealth/assets/colors.dart';

class CitaCard extends StatelessWidget {
  final Cita cita;

  CitaCard({required this.cita});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundWidgetColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Nombre de la cita: ${cita.tipoCita}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Fecha y hora: ${DateFormat('dd/MM/yyyy HH:mm').format(cita.fechaHoraCita)}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Hospital: ${cita.direccionHospital}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}