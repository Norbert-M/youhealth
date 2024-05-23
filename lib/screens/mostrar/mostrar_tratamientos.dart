import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:youhealth/Widgets/widget_evento.dart';
import 'package:youhealth/assets/colors.dart';

class TreatmentListPage extends StatefulWidget {
  @override
  _TreatmentListPageState createState() => _TreatmentListPageState();
}

class _TreatmentListPageState extends State<TreatmentListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> treatmentsStream;

  Future<String> getMedicamentoName(String idMedicamento) async {
    DocumentSnapshot medicamentoSnapshot = await FirebaseFirestore.instance
        .collection('medicamentos')
        .doc(idMedicamento)
        .get();
    return (medicamentoSnapshot.data() as Map<String, dynamic>)['nombre'] ?? '';
  }

  Future<String> getUserId(String idTratamiento) async {
    DocumentSnapshot tratamientoSnapshot = await FirebaseFirestore.instance
        .collection('tratamientos')
        .doc(idTratamiento)
        .get();
    return (tratamientoSnapshot.data() as Map<String, dynamic>)['idUser'] ?? '';
  }

  Future<String> getUserName(String idUser) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(idUser)
        .get();
    return (userSnapshot.data() as Map<String, dynamic>)['nombre'] ?? '';
  }

  @override
  void initState() {
    super.initState();
    treatmentsStream = _db.collection('ProximosTratamientos').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.barColor, // Cambiar el color del AppBar aquí
        title: const Text('Próximos Tratamientos',
            style: TextStyle(color: Colors.white),
        )
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: treatmentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: AppColors.backgroundColor, // Usar backgroundColor aquí
              child: FutureBuilder<List<Map<String, dynamic>?>>(
                future: Future.wait(snapshot.data!.docs.map((doc) async {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  String userId = await getUserId(data['idTratamiento']);
                  if (userId == _auth.currentUser!.uid) {
                    DateTime nextDose =
                        DateTime.fromMillisecondsSinceEpoch(data['hora']);
                    DateTime now = DateTime.now();
                    // Comprueba si la próxima dosis es hoy
                    if (nextDose.day == now.day &&
                        nextDose.month == now.month &&
                        nextDose.year == now.year) {
                      String medicamentoName = data[
                          'nombreMedicamento']; // Accede directamente al nombre del medicamento
                      return {
                        'title': medicamentoName,
                        'subtitle': 'Dosis: ${data['dosis']}',
                        'trailing': 'Siguiente dosis: ${nextDose.hour}:${nextDose.minute}',
                        'nextDose': nextDose, // Añade nextDose a los datos
                      };
                    }
                  }
                  return null;
                })),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<Map<String, dynamic>?> data = snapshot.data!;
                    List<Map<String, dynamic>> nonNullData = data.where((item) => item != null).toList().cast<Map<String, dynamic>>();
                    nonNullData.sort((a, b) => (a['nextDose'] as DateTime).compareTo(b['nextDose'] as DateTime)); // Sort by next dose
                    List<Widget> widgets = nonNullData.map((item) {
                      return TarjetaEvento(
                        titulo: item['title'] as String,
                        subtitulo: item['subtitle'] as String,
                        siguiente: item['trailing'] as String,
                      );
                    }).toList();
                    return ListView(
                      children: widgets,
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return CircularProgressIndicator();
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}