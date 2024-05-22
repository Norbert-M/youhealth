import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youhealth/Entity/medicamento.dart';

class AnadirMedicamentoPage extends StatefulWidget {
  @override
  _AnadirMedicamentoPageState createState() => _AnadirMedicamentoPageState();
}

class _AnadirMedicamentoPageState extends State<AnadirMedicamentoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cantidadStockController = TextEditingController();
  final _dosisController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Medicamento'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _cantidadStockController,
              decoration: InputDecoration(labelText: 'Cantidad en Stock'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la cantidad en stock';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dosisController,
              decoration: InputDecoration(labelText: 'Dosis (ml o mg)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la dosis';
                }
                return null;
              },
            ),
            ElevatedButton(
              child: Text('Añadir Medicamento'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Aquí puedes añadir el medicamento a la base de datos
                  // Por ejemplo, puedes añadirlo a Firestore
                  final medicamento = Medicamento(
                    idMedicamento: FirebaseFirestore.instance.collection('medicamentos').doc().id,
                    nombre: _nombreController.text,
                    cantidadStock: int.parse(_cantidadStockController.text),
                    dosis: _dosisController.text,
                  );
                  await FirebaseFirestore.instance.collection('medicamentos').doc(medicamento.idMedicamento).set(medicamento.toJson());
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