import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youhealth/Entity/cita_medico.dart';
import 'package:youhealth/Widgets/widget_cita.dart';
import 'package:youhealth/assets/colors.dart';
import 'package:youhealth/screens/mostrar/mostrar_detalle_cita.dart';

class MostrarCitasPage extends StatefulWidget {
  @override
  _MostrarCitasPageState createState() => _MostrarCitasPageState();
}

class _MostrarCitasPageState extends State<MostrarCitasPage> {
  final _usuarioActual = FirebaseAuth.instance.currentUser;

  Future<List<Cita>> getCitasUsuario() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cita_medico')
          .where('idUsuario', isEqualTo: _usuarioActual!.uid)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return [];
      } else {
        List<Cita> citas = [];
        for (var doc in querySnapshot.docs) {
          citas.add(Cita.fromJson(doc.data() as Map<String, dynamic>));
        }
        return citas;
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.barColor,
        title: Text('Mis Citas',
          style: TextStyle(color: Colors.white),
        )
      ),
      body: FutureBuilder<List<Cita>>(
        future: getCitasUsuario(),
        builder: (BuildContext context, AsyncSnapshot<List<Cita>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final cita = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleCitaPage(cita: cita),
                      ),
                    );
                  },
                  child: CitaCard(
                    cita: Cita(
                      idUsuario: cita.idUsuario,
                      tipoCita: cita.tipoCita,
                      nombreHospital: cita.nombreHospital,
                      fechaHoraCita: cita.fechaHoraCita,
                      direccionHospital: cita.nombreHospital,
                    ),
                  ),
                );
              },
            );
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}