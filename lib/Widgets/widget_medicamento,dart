import 'package:flutter/material.dart';
import 'package:youhealth/assets/colors.dart';

class MedicamentoHistorialItem extends StatelessWidget {
  final Map<String, dynamic> data;

  MedicamentoHistorialItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.barColor, // Aquí cambiamos el color de fondo
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          'Medicamento: ${data['nombre']}',
          style: TextStyle(color: Colors.white), 
        ),
        subtitle: Text(
          'Dosis: ${data['dosis']}',
          style: TextStyle(color: Colors.white), // Aquí cambiamos el color de la letra a blanco
        ),
      ),
    );
  }
}