import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:youhealth/Entity/cita_medico.dart';
import 'package:youhealth/Entity/hospital.dart';
import 'package:youhealth/assets/colors.dart'; // Asegúrate de tener esta entidad

class AnadirCitaPage extends StatefulWidget {
  @override
  _AnadirCitaPageState createState() => _AnadirCitaPageState();
}

class _AnadirCitaPageState extends State<AnadirCitaPage> {
  final _formKey = GlobalKey<FormState>();
  final _tipoCitaController = TextEditingController();
  final _direccionHospitalController = TextEditingController();
  DateTime _fechaHoraCita = DateTime.now();
  LatLng _ubicacionHospital =
      const LatLng(40.416775, -3.703790); // Coordenadas iniciales de Madrid
  Hospital? _hospitalSeleccionado;

  Future<void> _selectFechaHora(BuildContext context) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaHoraCita,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (fechaSeleccionada != null) {
      final TimeOfDay? horaSeleccionada = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_fechaHoraCita),
      );

      if (horaSeleccionada != null) {
        setState(() {
          _fechaHoraCita = DateTime(
            fechaSeleccionada.year,
            fechaSeleccionada.month,
            fechaSeleccionada.day,
            horaSeleccionada.hour,
            horaSeleccionada.minute,
          );
        });
      }
    }
  }

  Future<List<Hospital>> getHospitales() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('hospitales').get();
      if (querySnapshot.docs.isEmpty) {
        return [];
      } else {
        List<Hospital> hospitales = [];
        for (var doc in querySnapshot.docs) {
          DocumentSnapshot hospitalSnapshot = await FirebaseFirestore.instance
              .collection('hospitales')
              .doc(doc.id)
              .get();
          hospitales.add(Hospital.fromJson(
              hospitalSnapshot.data() as Map<String, dynamic>));
        }
        return hospitales;
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
        title: const Text('Añadir Cita',
          style: TextStyle(color: Colors.white),
        )
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            TextFormField(
              controller: _tipoCitaController,
              decoration: const InputDecoration(
                labelText: 'Tipo de Cita',
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
                  return 'Por favor ingrese el tipo de cita';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Fecha y Hora de la Cita'),
              subtitle:
                  Text(DateFormat('dd/MM/yyyy – HH:mm').format(_fechaHoraCita)),
              onTap: () => _selectFechaHora(context),
            ),
            SizedBox(height: 20.0),
            FutureBuilder<List<Hospital>>(
              future: getHospitales(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Hospital>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return DropdownButtonFormField<Hospital>(
                    decoration: const InputDecoration(
                      labelText: 'Hospital',
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.barColor, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    items: snapshot.data!.map((Hospital hospital) {
                      return DropdownMenuItem<Hospital>(
                        value: hospital,
                        child: Text(hospital.nombre),
                      );
                    }).toList(),
                    onChanged: (Hospital? hospital) {
                      if (hospital != null) {
                        _direccionHospitalController.text = hospital.direccion;
                        _ubicacionHospital =
                            LatLng(hospital.latitud, hospital.longitud);
                        _hospitalSeleccionado = hospital;
                      }
                    },
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
            SizedBox(height: 20.0),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: _ubicacionHospital,
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {},
              ),
            ),
            SizedBox(height: 20.0),
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
                    try {
                      final cita = Cita(
                        idUsuario: FirebaseAuth.instance.currentUser!.uid,
                        tipoCita: _tipoCitaController.text,
                        nombreHospital: _hospitalSeleccionado!.nombre,
                        fechaHoraCita: _fechaHoraCita,
                        direccionHospital: _direccionHospitalController.text,
                        latitudHospital: _hospitalSeleccionado?.latitud,
                        longitudHospital: _hospitalSeleccionado?.longitud,
                      );
                      await FirebaseFirestore.instance
                          .collection('cita_medico')
                          .doc()
                          .set(cita.toJson());
                      Navigator.pop(context);
                    } catch (e) {
                      // Aquí puedes manejar el error
                      print(e);
                    }
                  }
                },
                child: const Text('Añadir Cita', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
