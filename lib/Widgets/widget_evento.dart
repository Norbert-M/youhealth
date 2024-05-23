import 'package:flutter/material.dart';
import 'package:youhealth/assets/colors.dart';

class TarjetaEvento extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String siguiente;

  TarjetaEvento({required this.titulo, required this.subtitulo, required this.siguiente});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundWidgetColor, // Cambiar el color de fondo aquí
      margin: EdgeInsets.all(10),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textWidgetColor), // Cambiar el color del texto aquí
            ),
            SizedBox(height: 10),
            Text(
              subtitulo,
              style: TextStyle(fontSize: 16, color: AppColors.textWidgetColor), // Cambiar el color del texto aquí
            ),
            SizedBox(height: 10),
            Text(
              siguiente,
              style: TextStyle(fontSize: 16, color: AppColors.textWidgetColor), // Cambiar el color del texto aquí
            ),
          ],
        ),
      ),
    );
  }
}