import 'package:flutter/material.dart';
import 'package:youhealth/Widgets/bottom_nav_widget.dart';
import 'package:youhealth/Widgets/top_bar_widget.dart';
 // Asegúrate de importar el archivo correcto

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarWidget(),
      body: BottomNavWidget(),
    );
  }
}