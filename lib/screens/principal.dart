import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youhealth/assets/colors.dart';
import 'package:youhealth/screens/mostrar/mostrar_citas.dart';
import 'package:youhealth/screens/mostrar/mostrar_tratamientos.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _TreatmentListPageState createState() => _TreatmentListPageState();
}

class _TreatmentListPageState extends State<PrincipalPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> getUserName(String idUser) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(idUser)
        .get();
    return (userSnapshot.data() as Map<String, dynamic>)['nombre'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 217, 217, 217),
        title: FutureBuilder<String>(
          future: getUserName(_auth.currentUser!.uid),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return Text('Hola, ${snapshot.data}!');
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200, // Ancho de la imagen
              height: 200, // Altura de la imagen
              child: Image.asset('lib/assets/app_icon.png', fit: BoxFit.cover),
            ), // Asegúrate de reemplazar 'your_image.png' con la ruta de tu imagen
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.barColor, // color del texto
                minimumSize: const Size(200, 50), // tamaño del botón
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MostrarCitasPage()),
                );
              },
              child: const Text(
                'Mostrar Citas',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20), // Espacio entre los botones
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.barColor, // color del texto
                minimumSize: const Size(200, 50), // tamaño del botón
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TreatmentListPage()),
                );
              },
              child: const Text(
                'Mostrar Tratamientos',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
