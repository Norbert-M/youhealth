import 'package:flutter/material.dart';
import 'package:youhealth/screens/anyadir.dart';
import 'package:youhealth/screens/perfil.dart';

class TopBarWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.person),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PerfilPage()),
          );

          // Aquí puedes manejar el evento de clic en el icono de perfil
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            // Aquí puedes manejar el evento de clic en el icono de "+"

            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AnadirPage()),
          );
          },
        ),
      ],
    );
  }
}