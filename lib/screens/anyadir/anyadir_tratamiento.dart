import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AnadirTratamientoPage extends StatefulWidget {
  @override
  _AnadirTratamientoPageState createState() => _AnadirTratamientoPageState();
}

class _AnadirTratamientoPageState extends State<AnadirTratamientoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _dosisController = TextEditingController();
  final _horasController = TextEditingController();
  String? _medicamentoId;
  List<DropdownMenuItem<String>> _medicamentoItems = [];
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  void initState() {
    super.initState();
    _loadMedicamentos();
  }

  Future<void> _loadMedicamentos() async {
    QuerySnapshot medicamentosSnapshot = await FirebaseFirestore.instance.collection('medicamentos').get();
    setState(() {
      _medicamentoItems = medicamentosSnapshot.docs.map((doc) {
        return DropdownMenuItem<String>(
          value: doc.id,
          child: Text(doc['nombre']),
        );
      }).toList();
    });
  }

  List<DateTime> getFutureDoseTimes(DateTime startTime, DateTime endTime, int frequencyHours) {
    List<DateTime> times = [];
    DateTime nextTime = startTime.add(Duration(hours: 2+frequencyHours)); // Añade 8 horas al inicio
    while (nextTime.isBefore(endTime) || nextTime.isAtSameMomentAs(endTime)) {
      times.add(nextTime);
      nextTime = nextTime.add(Duration(hours: frequencyHours));
    }
    // Asegurarse de que el último registro, que es igual a la hora final, también se añada
    if (nextTime.isAtSameMomentAs(endTime)) {
      times.add(nextTime);
    }
    return times;
  }
  Future<String> getMedicamentoName(String idMedicamento) async {
    DocumentSnapshot medicamentoSnapshot = await FirebaseFirestore.instance
      .collection('medicamentos')
      .doc(idMedicamento)
      .get();
    return (medicamentoSnapshot.data() as Map<String, dynamic>)['nombre'] ?? '';
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      DateTime now = DateTime.now();
      DateTime dateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        now.hour,
        now.minute,
        now.second,
      );
      setState(() {
        if (isStartDate) {
          _fechaInicio = dateTime;
        } else {
          _fechaFin = dateTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Tratamiento'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: _medicamentoId,
              items: _medicamentoItems,
              onChanged: (value) {
                setState(() {
                  _medicamentoId = value;
                });
              },
              decoration: InputDecoration(labelText: 'Medicamento'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor seleccione un medicamento';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dosisController,
              decoration: InputDecoration(labelText: 'Dosis (por ejemplo, 1 pastilla)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la dosis';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _horasController,
              decoration: InputDecoration(labelText: 'Cada cuantas horas'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese cada cuantas horas se hace el tratamiento';
                }
                return null;
              },
            ),
            // Agrega los botones para seleccionar las fechas de inicio y final
            ElevatedButton(
              onPressed: () => _selectDate(context, true),
              child: Text('Seleccionar Fecha de Inicio'),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context, false),
              child: Text('Seleccionar Fecha Final'),
            ),
            ElevatedButton(
              child: Text('Añadir Tratamiento'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Aquí puedes añadir el tratamiento a la base de datos
                  // Por ejemplo, puedes añadirlo a Firestore
                  final tratamiento = {
                    'idTratamiento': FirebaseFirestore.instance.collection('tratamientos').doc().id,
                    'idMedicamento': _medicamentoId!,
                    'idUser': FirebaseAuth.instance.currentUser!.uid,
                    'dosis': _dosisController.text,
                    'frecuenciaHoras': int.parse(_horasController.text),
                    'fechaInicio': _fechaInicio!.millisecondsSinceEpoch, // Guarda la fecha como un timestamp
                    'fechaFin': _fechaFin!.millisecondsSinceEpoch, // Guarda la fecha como un timestamp
                  };
                  await FirebaseFirestore.instance.collection('tratamientos').doc(tratamiento['idTratamiento'] as String?).set(tratamiento);
            
                  // Calcula las horas de dosificación futuras y crea los registros en ProximosTratamientos
                  List<DateTime> futureDoseTimes = getFutureDoseTimes(_fechaInicio!, _fechaFin!, tratamiento['frecuenciaHoras'] as int);
                  for (DateTime doseTime in futureDoseTimes) {
                    String idMedicamento = tratamiento['idMedicamento'] as String;
                    String medicamentoName = await getMedicamentoName(idMedicamento);
                    final proximoTratamiento = {
                      'idTratamiento': tratamiento['idTratamiento'],
                      'hora': doseTime.millisecondsSinceEpoch, // Guarda la hora como un timestamp
                      'nombreMedicamento': medicamentoName, // Usa el nombre del medicamento obtenido
                      'idUser': _auth.currentUser!.uid, // Añade el id del usuario
                      'dosis': tratamiento['dosis'],
                    };
                    await FirebaseFirestore.instance.collection('ProximosTratamientos').add(proximoTratamiento);
                  }
            
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}