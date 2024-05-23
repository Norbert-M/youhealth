import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youhealth/assets/colors.dart';
import 'package:youhealth/screens/login.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Map<String, dynamic> data = {};
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};

  var orderedKeys = [
    'nombre',
    'apellido',
    'fechaNacimiento',
    'peso',
    'estatura',
    'correo'
  ];

  Future<void> loadData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot doc =
          await _db.collection('usuarios').doc(currentUser.uid).get();
      setState(() {
        data = doc.data() as Map<String, dynamic>;
        data.keys.forEach((key) {
          _controllers[key] = TextEditingController(text: data[key].toString());
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.barColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Detalles de tu perfil',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.barColor),
              ),
            ),
          ]..addAll(
              orderedKeys.map((key) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    height: 60.0, // Set the height
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      border: Border.all(
                        color: CupertinoColors.inactiveGray,
                        width: 0.0, // Remove border
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: CupertinoTextField(
                      controller: _controllers[key],
                      placeholder: key,
                      decoration: null,
                    ),
                  ),
                );
              }).toList(),
            ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            User? currentUser = _auth.currentUser;
            if (currentUser != null) {
              await _db.collection('usuarios').doc(currentUser.uid).update(
                    _controllers.map(
                        (key, controller) => MapEntry(key, controller.text)),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil actualizado')),
              );
            }
          }
        }, // Set the icon color to white
        backgroundColor: AppColors.barColor,
        child: const Icon(Icons.save,
            color: Colors.white),
      ),
    );
  }
}
