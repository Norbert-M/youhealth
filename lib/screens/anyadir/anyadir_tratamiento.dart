import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class AnadirTratamientoPage extends StatefulWidget {
  @override
  _AnadirTratamientoPageState createState() => _AnadirTratamientoPageState();
}

class _AnadirTratamientoPageState extends State<AnadirTratamientoPage> {
  final _formKey = GlobalKey<FormState>();
  final _dosisController = TextEditingController();
  final _horasController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaFinController = TextEditingController();
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
            TextFormField(
              controller: _fechaInicioController,
              decoration: InputDecoration(labelText: 'Fecha de inicio'),
              onTap: () async {
                FocusScope.of(context).requestFocus(new FocusNode()); // para quitar el teclado
                final fechaSeleccionada = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (fechaSeleccionada != null) {
                  _fechaInicio = fechaSeleccionada;
                  _fechaInicioController.text = DateFormat('dd/MM/yyyy').format(_fechaInicio!);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor seleccione la fecha de inicio';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _fechaFinController,
              decoration: InputDecoration(labelText: 'Fecha de fin'),
              onTap: () async {
                FocusScope.of(context).requestFocus(new FocusNode()); // para quitar el teclado
                final fechaSeleccionada = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (fechaSeleccionada != null) {
                  _fechaFin = fechaSeleccionada;
                  _fechaFinController.text = DateFormat('dd/MM/yyyy').format(_fechaFin!);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor seleccione la fecha de fin';
                }
                return null;
              },
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