import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youhealth/Entity/medicamento.dart';
import 'package:youhealth/assets/colors.dart';

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
        backgroundColor: AppColors.barColor,
        title: const Text('Añadir Medicamento',
          style: TextStyle(color: Colors.white),
        )
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
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
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _cantidadStockController,
              decoration: const InputDecoration(
                labelText: 'Cantidad en Stock',
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
                  return 'Por favor ingrese la cantidad en stock';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _dosisController,
              decoration: const InputDecoration(
                labelText: 'Dosis (ml o mg)',
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
            Container(
              decoration: BoxDecoration(
                color: AppColors.barColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
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
                child: const Text('Añadir Medicamento', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}