import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:youhealth/assets/colors.dart';

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

  Future<void> addTratamiento() async {
    if (_formKey.currentState!.validate()) {
      final tratamiento = {
        'idTratamiento': FirebaseFirestore.instance.collection('tratamientos').doc().id,
        'idMedicamento': _medicamentoId!,
        'idUser': FirebaseAuth.instance.currentUser!.uid,
        'dosis': _dosisController.text,
        'frecuenciaHoras': int.parse(_horasController.text),
        'fechaInicio': _fechaInicio!.millisecondsSinceEpoch,
        'fechaFin': _fechaFin!.millisecondsSinceEpoch,
      };
      await FirebaseFirestore.instance.collection('tratamientos').doc(tratamiento['idTratamiento'] as String?).set(tratamiento);
  
      List<DateTime> futureDoseTimes = getFutureDoseTimes(_fechaInicio!, _fechaFin!, tratamiento['frecuenciaHoras'] as int);
      for (DateTime doseTime in futureDoseTimes) {
        String idMedicamento = tratamiento['idMedicamento'] as String;
        String medicamentoName = await getMedicamentoName(idMedicamento);
        final proximoTratamiento = {
          'idTratamiento': tratamiento['idTratamiento'],
          'hora': doseTime.millisecondsSinceEpoch,
          'nombreMedicamento': medicamentoName,
          'idUser': _auth.currentUser!.uid,
          'dosis': tratamiento['dosis'],
        };
        await FirebaseFirestore.instance.collection('ProximosTratamientos').add(proximoTratamiento);
      }
  
      Navigator.pop(context);
    }
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
        backgroundColor: AppColors.barColor,
        title: const Text('Añadir Tratamiento',
          style: TextStyle(color: CupertinoColors.white),
        )
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              value: _medicamentoId,
              items: _medicamentoItems,
              onChanged: (value) {
                setState(() {
                  _medicamentoId = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Medicamento',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.barColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor seleccione un medicamento';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _dosisController,
              decoration: const InputDecoration(
                labelText: 'Dosis (por ejemplo, 1 pastilla)',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.barColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la dosis';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _horasController,
              decoration: const InputDecoration(
                labelText: 'Cada cuantas horas',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.barColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese cada cuantas horas se hace el tratamiento';
                }
                return null;
              },
            ),
            // Agrega los botones para seleccionar las fechas de inicio y final
            const SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                color: AppColors.barColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                onPressed: () => _selectDate(context, true),
                child: const Text('Seleccionar Fecha de Inicio', style: TextStyle(color: CupertinoColors.white)),
              ),
            ),
            
            const SizedBox(height: 20.0), // Añade separación
            Container(
              decoration: BoxDecoration(
                color: AppColors.barColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                onPressed: () => _selectDate(context, false),
                child: const Text('Seleccionar Fecha Final', style: TextStyle(color: CupertinoColors.white)),
              ),
            ),
            const SizedBox(height: 20.0), // Añade separación
            Container(
              decoration: BoxDecoration(
                color: AppColors.barColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                onPressed: () async {
                  await addTratamiento();
                },
                child: const Text('Añadir Tratamiento', style: TextStyle(color: CupertinoColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}