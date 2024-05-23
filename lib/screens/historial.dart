import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:youhealth/Widgets/widget_medicamento,dart';


class HistorialPage extends StatefulWidget {
  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Future<List<DocumentSnapshot>> futureMedicamentos;

  Future<List<DocumentSnapshot>> getMedicamentos() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot tratamientosSnapshot = await FirebaseFirestore.instance
        .collection('tratamientos')
        .where('idUser', isEqualTo: userId)
        .get();
    Set<String> medicamentoIds = {};
    List<DocumentSnapshot> medicamentos = [];
    for (var doc in tratamientosSnapshot.docs) {
      String medicamentoId = doc['idMedicamento'];
      if (!medicamentoIds.contains(medicamentoId)) {
        medicamentoIds.add(medicamentoId);
        DocumentSnapshot medicamentoSnapshot = await FirebaseFirestore.instance
            .collection('medicamentos')
            .doc(medicamentoId)
            .get();
        medicamentos.add(medicamentoSnapshot);
      }
    }
    return medicamentos;
  }

  @override
  void initState() {
    super.initState();
    futureMedicamentos = getMedicamentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 217, 217, 217),
        title: Text('Historial de Medicamentos'),
      ),
      body: Container(
        color: Color.fromARGB(255, 217, 217, 217),
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: futureMedicamentos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.map((doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  return MedicamentoHistorialItem(data: data) as Widget;
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}